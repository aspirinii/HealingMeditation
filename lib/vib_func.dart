import 'package:vibration/vibration.dart';

List<int> part1Pattern1(int sec){
    List<int> startPattern =  [50,100,50,100, 700];
    List<int> inPattern =  [for(var i=0; i<sec*2; i+=1) if (i%2 == 0) 100 else 900];
    List<int> vPattern1 =  startPattern + inPattern;
    return vPattern1;
}

List<int> part1Inten1(int sec){
    List<int> startIntensities =  [0, 255,0,255, 0];
    List<int> inIntensities =  [for(var i=0; i<sec*2; i+=1) if (i%2 == 0) 100 else 0];
    List<int> vInten1 =  startIntensities + inIntensities;
    return vInten1;
}


List<int> part2Pattern2(int sec){
  int fsmo = sec-1;
  List<int> vPattern2 =  [];
  if (fsmo < 0) {
    vPattern2 =  [];
  }
  else {                  
    vPattern2 =  [fsmo*1000,1000];
  }
  return vPattern2;

}

List<int> part2Inten2(int sec){
  int fsmo = sec-1;
  List<int> vIntensities2 = [];
  if (fsmo < 0) {
    vIntensities2 = [];
  }
  else {                  
    vIntensities2 = [100,0];
  }
  return vIntensities2;
}

List<int> part1Pattern(int sec){
  var index = 5;
  List<int> vPattern3= [for(var i=0; i<sec*index; i++) (1000/index).toInt()];
  return vPattern3;

}

List<int> part1Inten(int sec){
  var index = 5;
  var maxInten = 100;
  var step = maxInten/(sec*index); 
  List<int> vIntensities3 = [for(double i=0; i<sec*index; i++) (i*step).toInt()];
  return vIntensities3;
}


List<int> part2Pattern(int sec){
    List<int> vPattern1 =  [];
    for(var i=0; i<sec*3; i+=1) {
      if (i%3 == 0) {vPattern1.add(300);}
      else if (i%3==1) {vPattern1.add(100);}
      else if (i%3==2) {vPattern1.add(600);}
    }
      
    return vPattern1;
}

List<int> part2Inten(int sec){
    List<int> vInten =  [];
    for(var i=0; i<sec*3; i+=1) {
      if (i%3 == 0) {vInten.add(0);}
      else if (i%3==1) {vInten.add(100);}
      else if (i%3==2) {vInten.add(0);}
    }
    return vInten;
}

List<int> part3Pattern(int sec){
  var index = 5;
  List<int> vPattern3= [for(var i=0; i<sec*index; i++) (1000/index).toInt()];
  return vPattern3;

}

List<int> part3Inten(int sec){
  var index = 5;
  var maxInten = 100;
  var step = maxInten/(sec*index); 
  List<int> vIntensities = [for(double i=0; i<sec*index; i++) (i*step).toInt()];
  List<int> vIntensities3 =  List.from(vIntensities.reversed);
  return vIntensities3;
}

void HapticVib(int cycle, int inhaleSec, int fullSec, int exhaleSec, int emptySec){

  List<int> vPattern1 =  part1Pattern(inhaleSec);
  List<int> vIntensities1 = part1Inten(inhaleSec);

  List<int> vPattern2 =  part2Pattern(fullSec);
  List<int> vIntensities2 = part2Inten(fullSec);

  List<int> vPattern3 =  part3Pattern(exhaleSec);
  List<int> vIntensities3 = part3Inten(exhaleSec);

    List<int> vPattern4 =  part2Pattern(emptySec);
  List<int> vIntensities4 = part2Inten(emptySec);

  var sumP = vPattern1 + vPattern2 + vPattern3 + vPattern4;
  var sumI = vIntensities1 + vIntensities2 + vIntensities3 + vIntensities4 ;
  List<int>  combinePattern = [];
  List<int>  combineIntensities = [];
  for (int i=0; i<cycle; i++){
    combinePattern.addAll(sumP);
    combineIntensities.addAll(sumI);
  }

  Vibration.vibrate(
    pattern: combinePattern,
    intensities: combineIntensities,
  );
}