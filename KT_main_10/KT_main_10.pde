
/*   
 編輯時間 20161022
 創作者   Shinn
 
 開發版本 Processing 3.0.2
 nyARToolKit 5.0.9
 
 舞台大小 解析度 1024, 768
 Webcam   解析度  960, 720
 雲端儲存路徑    output        (依電腦路徑修改)
 
 參考
 //nyARToolKit,                          http://nyatla.jp/nyartoolkit/wp/
 //Generative Design: Lissajous curve,   http://www.generative-gestaltung.de/code
 */

import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture cam;
MultiMarker nya;
Lissajous liss;

PImage img1, img2, img3, img4, img5, img0, imgBG;
float hoff=0;           //文字png誤差 -10

//-----圖卡觸發
Boolean _chara1=false;  //青
Boolean _chara2=false;  //赤
Boolean _chara3=false;  //黃
Boolean _chara4=false;  //白
Boolean _chara5=false;  //黑
Boolean _chara6=false;  //存
float tmpAlpha=0;
float tmp1=0.5;
FloatList brushColor1, brushColor2;
float xoff = 0.0;
String Driver_URL = "C:/Users/Man/Google 雲端硬碟/KT_展示/";
int countFiles=0, countDown=0;
float tmpCx=0, tmpCy=0;
Boolean cap=false;

//nyartoolkit
PVector[] obj_paint1;
PVector cent_paint1;
PFont font;
Boolean camTmp=false;

//test
Boolean mouseTest=false;
Boolean paintTest=false;      //少用
Boolean pattTest=false;       //少用
Boolean vertTest=false;       //少用

float tmpPx=0;
float tmpPy=0;



//

float theta=0;
Boolean test=false; 
Boolean save=false;

Boolean saveFlag=false;        //20161112
Boolean save2=false;

void setup() {
  font=createFont("FFScala", 32);
  //size(1024, 768, OPENGL);
  fullScreen(OPENGL);

  //----image import
  img0 = loadImage("str0.png"); 
  img1 = loadImage("str1.png");
  img2 = loadImage("str2.png");
  img3 = loadImage("str3.png");
  img4 = loadImage("str4.png");
  img5 = loadImage("str5.png");  
  imgBG = loadImage("background_2.jpg");

  //-----graph class
  liss = new Lissajous();
  brushColor1 = new FloatList();
  brushColor2 = new FloatList();

  background(0);
  //colorMode(RGB, 255, 255, 255);
  image(imgBG, 0, 0);


  //---WebcamTest
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
  }

  //----nyARtoolkit & camera init
  println(MultiMarker.VERSION);
  cam=new Capture(this, 960, 720, 30);        //羅技 webcam c920
  //cam=new Capture(this, 640, 480, 30);        //羅技 webcam c920
  nya=new MultiMarker(this, 960, 720, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);

  nya.addARMarker("patt.point", 80);         //筆刷
  nya.addARMarker("patt.cing", 80);          //青
  nya.addARMarker("patt.chih", 80);          //赤
  nya.addARMarker("patt.yellow2", 80);         //黃
  nya.addARMarker("patt.bo", 80);            //白
  nya.addARMarker("patt.hei", 80);           //黑
  nya.addARMarker("patt.save", 80);          //存

  obj_paint1  = new PVector[4];
  cent_paint1 = new PVector(0, 0);

  noCursor();
  cam.start();
}
//float mx,my;

void draw() {
  smooth();
  colorMode(RGB, 255, 255, 255);

  //----webCam init
  if (cam.available() !=true) return;
  cam.read();

  //if (camFlag==true) nya.drawBackground(cam);
  nya.detect(cam);

  //----Adjust
  if (camTmp) {
    background(255);
    paintTest=true;
  }

  //----pattern detection
  if (mouseTest==false) {
    if (nya.isExistMarker(0)) {
      //println("Paint1 ");
      //----Marker Postion
      obj_paint1 = nya.getMarkerVertex2D(0);
      cent_paint1.y= ((obj_paint1[0].y+obj_paint1[1].y)/2+(obj_paint1[2].y+obj_paint1[3].y)/2)/2;    
      float mx= ((obj_paint1[0].x+obj_paint1[1].x)/2+(obj_paint1[2].x+obj_paint1[3].x)/2)/2;
      float my= ((obj_paint1[0].y+obj_paint1[1].y)/2+(obj_paint1[2].y+obj_paint1[3].y)/2)/2;

      cent_paint1.x = map(mx, 0, width, width, 0);
      cent_paint1.y = map(my, 0, height, height, 0);
      //println(" " + cent_paint1.x);


      if (paintTest) {
        noStroke();
        fill(255, 0, 0, 50);
        ellipse(cent_paint1.x, cent_paint1.y, 20, 20);
      }
      //----TEST
      if (pattTest) drawMarkerPatt(0);
      if (vertTest) drawVertex(0);
    }

    if (nya.isExistMarker(1)) {
      //println("Pattern 青 ");    
      cap=false;
      _chara1=true;
      _chara2=false;
      _chara3=false;
      _chara4=false;
      _chara5=false;
      _chara6=false;
      brushColor1.clear();
      brushColor2.clear();    
      liss.reset();
      countDown=0;
      test=false;
      saveFlag=false;
      save2=false;

      //----TEST
      if (pattTest) drawMarkerPatt(0);
      if (vertTest) drawVertex(0);
    }
    if (nya.isExistMarker(2)) {
      //println("Pattern 赤 ");
      cap=false;
      _chara1=false;
      _chara2=true;
      _chara3=false;
      _chara4=false;
      _chara5=false;
      _chara6=false;
      brushColor1.clear();
      brushColor2.clear();    
      liss.reset();
      countDown=0;
      test=false;
      saveFlag=false;
      save2=false;
      
      //----TEST
      if (pattTest) drawMarkerPatt(0);
      if (vertTest) drawVertex(0);
    }
    if (nya.isExistMarker(3)) {
      //println("Pattern 黃 ");
      cap=false;
      _chara1=false;
      _chara2=false;
      _chara3=true;
      _chara4=false;
      _chara5=false;
      _chara6=false;
      brushColor1.clear();
      brushColor2.clear();    
      liss.reset();
      countDown=0;
      test=false;
      saveFlag=false;      
      save2=false;

      //----TEST
      if (pattTest) drawMarkerPatt(0);
      if (vertTest) drawVertex(0);
    }
    if (nya.isExistMarker(4)) {
      //println("Pattern 白 ");
      cap=false;
      _chara1=false;
      _chara2=false;
      _chara3=false;
      _chara4=true;
      _chara5=false;
      _chara6=false;
      brushColor1.clear();
      brushColor2.clear();    
      liss.reset();
      countDown=0;
      test=false;
      saveFlag=false;
      save2=false;

      //----TEST
      if (pattTest) drawMarkerPatt(0);
      if (vertTest) drawVertex(0);
    }
    if (nya.isExistMarker(5)) {
      //println("Pattern 黑 ");
      cap=false;
      _chara1=false;
      _chara2=false;
      _chara3=false;
      _chara4=false;
      _chara5=true;
      _chara6=false;
      brushColor1.clear();
      brushColor2.clear();    
      liss.reset();
      countDown=0;
      test=false;
      saveFlag=false;      
      save2=false;

      //----TEST
      if (pattTest) drawMarkerPatt(0);
      if (vertTest) drawVertex(0);
    }
    if (nya.isExistMarker(6)) {
      //println("Pattern 存 ");
      _chara6=true;
      cap=true;
      //----TEST
      if (pattTest) drawMarkerPatt(0);
      if (vertTest) drawVertex(0);
    }
  }


  if (camTmp==false) {


    //----Card function start
    if (_chara1) {
      //println("青");
      image(imgBG, 0, 0);
      noStroke();
      ellipse(width/2, height/2+10, 730, 730);

      cardFunc();
      //tint(255);
      //image(img0, width/2-670/2, height/2-670/2);
      tint(255, tmpAlpha);
      image(img1, width/2-538/2, height/2-538/2+hoff);

      tmpCx = map(tmpPx, 0, width, 0, width/2);
      tmpCy = map(tmpPy, 0, height, 200, 250+300);
    } else if (_chara2) {
      //println("赤");
      image(imgBG, 0, 0);
      noStroke();
      ellipse(width/2, height/2+10, 730, 730);

      cardFunc();
      //tint(255);
      //image(img0, width/2-670/2, height/2-670/2);
      tint(255, tmpAlpha);
      image(img2, width/2-538/2, height/2-538/2+hoff);

      //tmpCx = map(tmpPx, 0, width, width/2-40, width-40);
      //tmpCy = map(tmpPy, 0, height, height/2-150, height/2+80);

      tmpCx = map(tmpPx, 0, width, width/2, width);
      tmpCy = map(tmpPy, 0, height, 0, height/2);
    } else if (_chara3) {
      //println("黃");
      image(imgBG, 0, 0);
      noStroke();
      ellipse(width/2, height/2+10, 730, 730);


      cardFunc();
      //tint(255);
      //image(img0, width/2-620/2, height/2-620/2);
      tint(255, tmpAlpha);
      image(img3, width/2-538/2, height/2-538/2+hoff);

      tmpCx = map(tmpPx, 0, width, width/2-50, width-50);
      tmpCy =map(tmpPy, 0, height, height/2-180, height-180);
    } else if (_chara4) {
      //println("白");
      image(imgBG, 0, 0);
      noStroke();
      ellipse(width/2, height/2+10, 730, 730);

      cardFunc();
      //tint(255);
      //image(img0, width/2-620/2, height/2-620/2);
      tint(255, tmpAlpha);
      image(img4, width/2-538/2, height/2-538/2+hoff);

      xoff = xoff + .1;
      float n = noise(xoff) * 77;
      tmpCx = (width/3)+n;
      tmpCy = (height/3)+n;
    } else if (_chara5) {
      //println("黑");
      image(imgBG, 0, 0);
      noStroke();
      ellipse(width/2, height/2+10, 730, 730);

      cardFunc();
      //tint(255);
      //image(img0, width/2-620/2, height/2-620/2);
      tint(255, tmpAlpha);
      image(img5, width/2-538/2, height/2-538/2+hoff);

      tmpCx = map(tmpPx, 0, width, 100, width/2+50);
      tmpCy = map(tmpPy, 0, height, 0, height/2-50);
    } 

    //----利薩如曲線(Lissajous curve) 
    liss.render(tmpPx, tmpPy, tmpCx, tmpCy);
    for (int i=1; i<liss.dataPos.size(); i++) {
      PVector p1 = (PVector) liss.dataPos.get(i);
      PVector p2 = (PVector) liss.dataPos.get(i-1);
      liss.drawLine(p1, p2, brushColor1.get(i), brushColor2.get(i)); 
      //println(tmpCx + "  " + tmpCy);

      for (int j=0; j<i; j++) {    
        PVector p3 = (PVector) liss.dataPos.get(i);
        PVector p4 = (PVector) liss.dataPos.get(j);
        liss.drawLine(p3, p4, brushColor1.get(i), brushColor2.get(i));
      }
    }

    //-----"存"動畫
    if (test==true) {
      //tmpAlpha=0;
      theta+=TWO_PI/100;
      alpha = map(sin(theta), -1, 1, 50, 180);
      noStroke();
      fill(255, alpha);      
      ellipse(width/2, height/2+10, 720, 720);
      //if (alpha<=50) {
      //  test=false;                      //"存"動畫
      //  fill(255);      
      //  ellipse(width/2, height/2+10, 720, 720);
      //}
    } else {
      alpha=0;
    }

    if (save2) {
      countDown++;
      if (countDown==100) {
        println("Save file");
        save=true;
        countFiles++;
        if (countFiles<10) saveFrame(Driver_URL + '0' + countFiles + ".jpg");
        else saveFrame(Driver_URL + countFiles + ".jpg");
      }
    }

    if (_chara6==true && saveFlag==false) {
      //println("Save function start.");    
      saveFlag=true;
      save2=true;
      //countDown++;
      test=true;      //"存"動畫
      //println(countDown);
      //tmpAlpha=0;
      //println("Save file");
      //save=true;
      //countFiles++;
      //if (countFiles<10) saveFrame(Driver_URL + '0' + countFiles + ".jpg");
      //else saveFrame(Driver_URL + countFiles + ".jpg");


      //if (save==false) {
      //  println("Save file");
      //  save=true;
      //  countFiles++;
      //  if (countFiles<10) saveFrame(Driver_URL + '0' + countFiles + ".jpg");
      //  else saveFrame(Driver_URL + countFiles + ".jpg");
      //}


      //if (countDown==200) {
      //  println("Save Reset");
      //  countDown=0;
      //  save=false;
      //  //_chara6=false;
      //}
    }

    if (mouseTest) {
      if (mouseX>145 && mouseX<740+130 && mouseY>0 && mouseY<740) {
        tmpPx = mouseX;
        tmpPy = mouseY;
      }
    } else {
      if (cent_paint1.x>145 && cent_paint1.x<740+130 && cent_paint1.y>10 && cent_paint1.y<740) {
        tmpPx = cent_paint1.x;
        tmpPy = cent_paint1.y;
      }
    }
  }
}

float alpha;

void cardFunc() {
  if (cap) tmpAlpha=1;
  else {
    tmpAlpha+=tmp1;
    if (tmpAlpha>=40) tmp1*=-1;
    else if (tmpAlpha<=0) tmp1*=-1;
  }
}

void keyPressed() {
  if (key == 'q' || key == 'Q' ) {
    cap=false;
    _chara1=true;
    _chara2=false;
    _chara3=false;
    _chara4=false;
    _chara5=false;
    _chara6=false;
    brushColor1.clear();
    brushColor2.clear();    
    liss.reset();
  }
  if (key == 'w' || key == 'W') {
    cap=false;
    _chara1=false;
    _chara2=true;
    _chara3=false;
    _chara4=false;
    _chara5=false;
    _chara6=false;
    brushColor1.clear();
    brushColor2.clear();    
    liss.reset();
  }
  if (key == 'e' || key == 'E') {
    cap=false;
    _chara1=false;
    _chara2=false;
    _chara3=true;
    _chara4=false;
    _chara5=false;
    _chara6=false;
    brushColor1.clear();
    brushColor2.clear();    
    liss.reset();
  }
  if (key == 'r' || key == 'R') {
    cap=false;
    _chara1=false;
    _chara2=false;
    _chara3=false;
    _chara4=true;
    _chara5=false;
    _chara6=false;
    brushColor1.clear();
    brushColor2.clear();    
    liss.reset();
  }
  if (key == 't' || key == 'T') {
    cap=false;
    _chara1=false;
    _chara2=false;
    _chara3=false;
    _chara4=false;
    _chara5=true;
    _chara6=false;
    brushColor1.clear();
    brushColor2.clear();    
    liss.reset();
  }
  if (key == 'y' || key == 'Y') {
    _chara6=true;
    cap=true;
  }

  if (key == 'c' || key == 'C' ) {
    if (camTmp==false) {
      camTmp = true;
    } else if (camTmp==true) {
      camTmp = false;
      paintTest=false;
      image(imgBG, 0, 0);
    }
  }
}


void mousePressed() {
  println("----------");
  println("Adjust:   " + mouseX + "\t" + mouseY);
  println("Position: " + cent_paint1.x + "\t" +  cent_paint1.y);  
  println("offSet:   " + (mouseX-cent_paint1.x) + "\t" + (mouseY-cent_paint1.y) );
}

//この関数は、マーカパターンを描画します。
void drawMarkerPatt(int id)
{
  PImage p=nya.pickupMarkerImage(id, 
    40, 40, 
    -40, 40, 
    -40, -40, 
    40, -40, 
    100, 100);
  //  PImage p=nya.pickupRectMarkerImage(id,-40,-40,80,80,100,100);
  image(p, id*100, 0);
}

//この関数は、マーカ頂点の情報を描画します。
void drawVertex(int id)
{
  PVector[] i_v=nya.getMarkerVertex2D(id);
  //textFont(font,10.0);
  stroke(100, 0, 0);

  for (int i=0; i<4; i++) {
    fill(100, 0, 0);
    ellipse(i_v[i].x, i_v[i].y, 6, 6);
    fill(0, 0, 0);
    text("("+i_v[i].x+","+i_v[i].y+")", i_v[i].x, i_v[i].y);
  }
}