
# this script splits the infield into inner and outer portions
# resolves issue #1
# https://github.com/bdilday/GeomMLBStadiums/issues/1

load("data/MLBStadiaPathData.rda")
df1 = MLBStadiumsPathData
#df1 = read.csv("inst/extdata/mlb_stadia_paths.csv", stringsAsFactors = FALSE)

update_paths_df = function(paths_df) {

  outfield_df = paths_df[which(grepl("outfield", paths_df$segment)),]
  infield_df = paths_df[which(grepl("infield", paths_df$segment)),]
  foul_df = paths_df[which(grepl("foul_lines", paths_df$segment)),]
  hp_df = paths_df[which(grepl("home_plate", paths_df$segment)),]

  # first update the generic field
  cc = which( (infield_df$team == "generic"))
  if (length(cc) > 0) {
    tmp = infield_df[cc,]
    tmp$segment = "infield_outer"
  }

  # now loop over the others
  ll = lapply(unique(infield_df$team), function(s) {
    if (s == "generic") {
      NULL
    } else if (s == "blue_jays") {
      a = split_path_df(infield_df, s) %>% select(-s)
      a[1:(nrow(a)-1),]
    } else {
      a = split_path_df(infield_df, s) %>% select(-s)
    }
  })

  others = do.call(rbind.data.frame, ll)
  if (length(cc) > 0) {
    rr = rbind.data.frame(tmp, others, outfield_df, foul_df, hp_df)
  } else {
    rr = rbind.data.frame(others, outfield_df, foul_df, hp_df)
  }

}

pair_distance = function(r1, r2) {
  sqrt((r1$x - r2$x)**2 + (r1$y - r2$y)**2)
}

get_dist_df = function(paths_df, team) {
  tmp = paths_df[(paths_df$team == team) & (paths_df$segment == "infield"),]
  ll = lapply(2:nrow(tmp), function(i) {
    r1 = tmp[i-1,]
    r2 = tmp[i,]
    r1$s = pair_distance(r1, r2)
    r1
  })
  dist_df = do.call(rbind.data.frame, ll)
}

split_path_df = function(paths_df, team) {
  dist_df = get_dist_df(paths_df, team)
  message(max(dist_df$s))
  idx = which(dist_df$s == max(dist_df$s))

  # split into two dfs
  df1 = dist_df[1:idx,]
  df2 = dist_df[(idx+1):nrow(dist_df),]

  df1 = rbind.data.frame(df1, df1[1,])
  df2 = rbind.data.frame(df2, df2[1,])
  # find which one is inner, by finding the max of distance
  # from the reference point (125, 199)

  m1 = max( (df1$x- 125)**2 + (df1$y - 199)**2)
  m2 = max( (df2$x- 125)**2 + (df2$y - 199)**2)

  if (m1 < m2) {
    df1$segment = "infield_inner"
    df2$segment = "infield_outer"
    rbind.data.frame(df1, df2)
  } else {
    df2$segment = "infield_inner"
    df1$segment = "infield_outer"
    rbind.data.frame(df2, df1)
  }

}

