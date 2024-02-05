class OurTimeLeft{
  List<String>timeLeft(dynamic time){
    List<String>retVal=[];
    //remaining time
    Duration _timeUntilDue=time.difference(DateTime.now());
    int _daysUntil=_timeUntilDue.inDays;
    int _hoursUntil=_timeUntilDue.inHours-24*_daysUntil;
    int _minUntil=_timeUntilDue.inMinutes-_hoursUntil*60-_daysUntil*24*60;
    int _secUntil=_timeUntilDue.inSeconds-_minUntil*60-_hoursUntil*60*60-_daysUntil*24*60*60;
    if(_daysUntil>0){
      retVal.add(_daysUntil.toString()+' days\n'+_hoursUntil.toString()+' hours\n'+_minUntil.toString()+'min\n'+_secUntil.toString()+'sec');
    }else if(_hoursUntil>0){
      retVal.add(_hoursUntil.toString()+' hours\n'+_minUntil.toString()+'min\n'+_secUntil.toString()+'sec');
    }else if(_minUntil>0){
      retVal.add(_minUntil.toString()+'min\n'+_secUntil.toString()+'sec');
    }else if(_secUntil>0){
      retVal.add(_secUntil.toString()+'sec');
    }else{
      retVal.add("error");
    }
    //next book is Reveled 7 days prior to the current-book-is-due
    Duration _timeUntilReveal=time.subtract(Duration(days: 7)).difference(DateTime.now());
    int _daysUntilReveal=_timeUntilReveal.inDays;
    int _hoursUntilReveal=_timeUntilReveal.inHours-24*_daysUntilReveal;
    int _minUntilReveal=_timeUntilReveal.inMinutes-_hoursUntilReveal*60-_daysUntilReveal*24*60;
    int _secUntilReveal=_timeUntilReveal.inSeconds-_minUntilReveal*60-_hoursUntilReveal*60*60-_daysUntilReveal*24*60*60;
    if(_daysUntilReveal>0){
      retVal.add(_daysUntilReveal.toString()+' days\n'+_hoursUntilReveal.toString()+' hours\n'+_minUntilReveal.toString()+'min\n'+_secUntilReveal.toString()+'sec');
    }else if(_hoursUntilReveal>0){
      retVal.add(_hoursUntilReveal.toString()+' hours\n'+_minUntilReveal.toString()+'min\n'+_secUntilReveal.toString()+'sec');
    }else if(_minUntilReveal>0){
      retVal.add(_minUntilReveal.toString()+'min\n'+_secUntilReveal.toString()+'sec');
    }else if(_secUntilReveal>0){
      retVal.add(_secUntilReveal.toString()+'sec');
    }else{
      retVal.add("error");
    }

    return retVal;
  }
}