pickFields<-function(sas,picks=c("casenum","reg","race","sex","agedx","yrbrth",
                                 "seqnum","modx","yrdx","histo3",#"radiatn", #"recno","agerec",
                                 "ICD9",#"numprims",
                                 "COD","surv","radiatn","chemo") ){
  # sas = df 
  notRows=setdiff(picks,sas$names)
  if (length(notRows)>0) stop(paste0("The following picks are not allowed: ",paste(notRows,collapse=", ")))
  ncols=dim(sas)[1] # in the SEER data files
  nBytesP1=sum(sas[ncols,1:2]) # number of bytes per cancer case in SEER, plus 1
  rownames(sas)<-sas$names
  ord=1:ncols
  names(ord)=sas$names
  ord=ord[picks]
  picks=names(sort(ord))
   # musts=c("reg","race","sex","agedx","histo3","radiatn","ICD9") # don't let the user not pick these
   musts=c("reg","race","sex","agedx","histo3","ICD9","radiatn","chemo") # don't let the user not pick these
   # musts=c("reg","race","sex","agedx","histo3","radiatn","agerec","ICD9") # don't let the user not pick these
  missing=setdiff(musts,picks)
  if (!all(musts%in%picks)) {cat("Picks must at least include:")
                             print(musts)
                             stop("\n  The following picks are missing: ",paste(missing,collapse=", "))}
  #   picks=union(musts,picks)  # problem with this is that it did not preserve the order in sas, which it must
  sas=sas[picks,]
  N=length(picks) # number of columns in our version of interest of the SEER data
  
  # db file size increases if the following is set to strings instead of integers
  sas=cbind(sas,type="integer",stringsAsFactors=FALSE)  
  # the following appear to be the only columns that contain letters
  if("siteo2" %in% sas$names) sas["siteo2","type"]="string"
  if("ICD10" %in% sas$names) sas["ICD10","type"]="string"
  if("eod13" %in% sas$names) sas["eod13","type"]="string"
  if("eod2" %in% sas$names) sas["eod2","type"]="string"
  if("primsite" %in% sas$names) sas["primsite","type"]="string"
  if("plcbrthcntry" %in% sas$names) sas["plcbrthcntry","type"]="string"
  if("plcbrthstate" %in% sas$names) sas["plcbrthstate","type"]="string"
  #new block of 2016+ problems
  if("tumsizs" %in% sas$names) sas["tumsizs","type"]="string"
  if("dsrpsg" %in% sas$names) sas["dsrpsg","type"]="string"
  if("dasrct" %in% sas$names) sas["dasrct","type"]="string"
  if("dasrcn" %in% sas$names) sas["dasrcn","type"]="string"
  if("dasrcm" %in% sas$names) sas["dasrcm","type"]="string"
  if("dasrcts" %in% sas$names) sas["dasrcts","type"]="string"
  if("dasrcns" %in% sas$names) sas["dasrcns","type"]="string"
  if("dasrcms" %in% sas$names) sas["dasrcms","type"]="string"
  if("tnmednum" %in% sas$names) sas["tnmednum","type"]="string"
  if("metsdxln" %in% sas$names) sas["metsdxln","type"]="string"
  if("metsdxo" %in% sas$names) sas["metsdxo","type"]="string"
  if (picks[1]=="casenum") outdf=sas[1,,drop=F] else  
    outdf=data.frame(start=1,width=sas$start[1]-1,names=" ",desc=" ",type="string")
  for (i in 2:N) 
    if (sas$start[i]==(up<-sas$start[i-1]+sas$width[i-1]) ) 
      outdf=rbind(outdf,sas[i,]) else {
        outdf=rbind(outdf,data.frame(start=up,width=(sas$start[i]-up),sasnames=" ",names=" ",desc=" ",type="string")) 
        outdf=rbind(outdf,sas[i,])
      }
  if ((up<-sas$start[i]+sas$width[i])<nBytesP1)
    outdf=rbind(outdf,data.frame(start=up,width=(nBytesP1-up),sasnames=" ",names=" ",desc=" ",type="string")) 
  outdf$type=as.character(outdf$type)
  if (any(outdf$width<0)) stop("Negative field width. One of your picks may be out of order!") 
  # if (any(outdf$width<0)) stop("Negative field width. One of your picks may be out of order: ", 
                               # paste(rownames(outdf)[which(outdf$width<0)-1],collapse=", "))
  outdf	 
}  # pickFields(df)