common_junc = read.csv("datahack_jerusalem_151125/frame_db.csv")


get_road_info = function(frame, filedat){
  rng = 7:30
  lroad = matrix(filedat$road[[1]],nc = 4)[frame,]
  rroad = matrix(filedat$road[[2]],nc = 4)[frame,]
  
  
  rightmod =  lroad[1]*(rng)^3 + lroad[2]* (rng)^2 + 
    lroad[3]*(rng) +lroad[4] *rep(1,length(rng))
  leftmod = rroad[1]*(rng)^3 + rroad[2]* (rng)^2 +
    rroad[3]*(rng) +rroad[4] *rep(1,length(rng))
  bothmod = leftmod + rightmod
  linmod = lm(bothmod ~ rng + I(rng^2))
  feats = linmod$coef[2:3]
  return(feats)
}

common_junc$road_lin = 0
common_junc$road_quad = 0
common_junc$frameIdx = 0

for (j in 1:nrow(common_junc)){
  f_ind = which(common_junc[j,4] == matfiles)
  if (f_ind > 357){
    tmpdat = cells[[f_ind]]
#    tmpdat = readMat(matfiles[[f_ind]])
#  }
  gps_position = common_junc[j,5]
  idx_frame = tmpdat$gps[[3]][gps_position]
  common_junc$frameIdx[j] = idx_frame
  
  video_position = which(tmpdat$frameIdx==idx_frame)
  
  road_inf = get_road_info(frame = video_position,filedat = tmpdat) 
  common_junc$road_lin[j] = road_inf[1]
  common_junc$road_quad[j] = road_inf[2]
  cat('.')
}
}
common_junc$road_both = common_junc$road_lin *20 + common_junc$road_quad*20^2

write.csv(file = 'with_road.csv', common_junc )
