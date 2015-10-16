/**
 * 型
 */
 import flash.display.DisplayObject;
 import flash.display.Stage;
 import flash.display.StageScaleMode;
 import flash.media.SoundChannel;
 import flash.media.SoundTransform;
 import flash.net.SharedObject;
 
 import mx.collections.ArrayCollection;
 import mx.controls.Text;
 import mx.effects.SoundEffect;
  
var _stage:Stage = null;
var _style:Array = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ];
var _needXien:Array = [ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1, 1,1,1, 1,1,1, 1,1,1, 1,1,1, 1,1,1, 1,1,1 ];
var _xi:Array = [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0 ];
var _bonusPoints:Number = 0;
var _shiftKeyDown:Boolean = false;

var stLog:Array = new Array(300);
var tmpStLog:Array = new Array(300);
var stackLog:String = "";
var log:Array = new Array(1024);
var logindex:Number = 0;
var focusLogarea = false;
var tmpXien:Number = 0;
var tmpBonusExpected:Number = 50;
var keyListener:Object = new Object();
var so:SharedObject = SharedObject.getLocal("soundVolume");
var st:SoundTransform = new SoundTransform();
var tmpx:Number = 0;

//初期化
public function initApp(event):void  {
    
    changeChar(0);
    
    st.volume = 0.5;

    lvupSe.startDelay = 0;
    lvupSe.startTime = 0;
    stupSe.startDelay = 0;
    stupSe.startTime = 0;
    
    if(so.data.volume != undefined) {
        volume.value = so.data.volume;
        st.volume = (volume.value / 100);
    }

    if(ExternalInterface.available == false || ExternalInterface.call("getClipboard") == undefined) {
      pasteB.enabled = false;
      pasteB.visible = false;
    }

    application.setFocus(); 
    application.addEventListener(Event.DEACTIVATE , deActivate);
    application.addEventListener(KeyboardEvent.KEY_UP, keyUp);
    application.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
    
    _stage = application.parent.stage;
    if(_stage != null) {
        _stage.scaleMode = StageScaleMode.SHOW_ALL;
    }
}

public function openDrop():void {
    tmpx = xienCB.selectedIndex;
}

public function changeVolume(v:Number):void {
    so.data.volume = v;
    st.volume = (v / 100);
}
public function deActivate(event):void {

    _shiftKeyDown = false;
    
}
public function keyUp(event:KeyboardEvent):void {

    _shiftKeyDown = event.shiftKey;

}
public function keyDown(event:KeyboardEvent):void {

    _shiftKeyDown = event.shiftKey;
    
    if(focusLogarea == false && w.visible == false) {
        if(event.keyCode == 76) {
            lvupPress();
        }
        if(event.keyCode == 83) {
            stupPress(0);
        }
        if(event.keyCode == 72) {
            stupPress(1);
        }
        if(event.keyCode == 73) {
            stupPress(2);
        }
        if(event.keyCode == 70) {
            stupPress(3);
        }
        if(event.keyCode == 77) {
            stupPress(4);
        }
        if(event.keyCode == 88) {
            stupPress(5);
        }
        if(event.keyCode == 65) {
            stupPress(6);
        }
        if(event.keyCode == 37) {
           backPress();
        }
        if(event.keyCode == 39) {
           progressPress();
        }
        if(event.keyCode == 71) {
            guidePress();
        }
        if(event.keyCode == 80) {
            logLoadPress();
        }
        if(event.keyCode == 84) {
            statusEdit();
        }
        if(event.keyCode ==  13) {
           var txt:String = logarea.text;
           
           logarea.setFocus();
           focusLogarea = true;
           logarea.text = txt;
        }
    }
    if(event.keyCode == 27) {
        application.setFocus(); 
        focusLogarea = false;
    }
    //logarea.text = String(event.shiftKey);
}

public function lvupPress() {
       if(parseInt(lv.text) < MAX_LEVEL) {

          lvupSe.sound.play(0,0,st);
          lvup();
          logOut();
          updateStatus();
       }
    application.setFocus();
}
public function stupPress(n:Number):void {
    var pArray:Array = [p0,p1,p2,p3,p4,p5,p6]; 
    
    if(_shiftKeyDown) {
        stdupPress(n);
        return;
    }

    if(parseInt(s11.text) >= parseInt((pArray[n] as Text).text)) {

        stupSe.sound.play(0,0,st);
        stup(n);
        logOut();
        updateStatus();
    }
    application.setFocus();
}
public function stdupPress(n:Number):void {
    var sArray:Array = [s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,0,s11]; 

    if(parseInt((sArray[n] as Text).text) < MAX_STATUS[n]) {

        stupSe.sound.play(0,0,st);
        stdup(n);
        logOut();
        updateStatus();
    }
    application.setFocus();
}
public function resetPress():void {
    reset();
    updateStatus();
    application.setFocus();
}
public function backPress():void {

    if(_shiftKeyDown) {
        dashBack();
        
    } else {
        back();
        
    }
    updateStatus();
    application.setFocus();
}
public function progressPress():void {

    if(_shiftKeyDown) {
        dashProgress();
        
    } else {
        progress();
    }
    updateStatus();
    application.setFocus();
}
public function guidePress():void {
    if(logindex > 0 ) {
        recipe();
    }
    application.setFocus();
}
public function pastePress():void {
    
    if(ExternalInterface.available) {
        
        logarea.text = String(replaceText(ExternalInterface.call("getClipboard"),"\r\n","\r"));    
    }
    application.setFocus();
};
public function logLoadPress():void {
    logLoad();
    updateStatus();
    application.setFocus();
}
public function copyPress():void {
    System.setClipboard(replaceText(logarea.text,"\r","\r\n"));
    application.setFocus();
};
public function clearPress():void {
    logarea.text = "";
    application.setFocus();
};
public function closeStatusEdit():void {

    w.visible = false;
    application.setFocus();
}
public function commitStatusEditPress():void {

    lv.text = String(slv.value);
    
    s0.text = String(ss0.value);
    s1.text = String(ss1.value);
    s2.text = String(ss2.value);
    s3.text = String(ss3.value);
    s4.text = String(ss4.value);
    s5.text = String(ss5.value);
    s6.text = String(ss6.value);
    s7.text = String(ss7.value);
    s8.text = String(ss8.value);
    s9.text = String(ss9.value);
    //s10.text = String(ss10.value);
    s11.text = String(ss11.value);
    
    s7mx.text = String(ss7.value);
    s7mi.text = String(ss7.value);
    s8mx.text = String(ss8.value);
    s8mi.text = String(ss8.value);
    s9mx.text = String(ss9.value);
    s9mi.text = String(ss9.value);
    //s10mx.text = String(ss10.value);
    //s10mi.text = String(ss10.value);
    
    var len:Number = xienList.length, x:Array = _xi, max:Number = 0, maxIndex:Number = 0;
        
    for(var i:Number = 0; i < len; i++) {
        x[parseInt(xienList.getItemAt(i).data)] = parseInt(sxiList.getItemAt(i).xienData);
        if(sxiList.getItemAt(i).xienData >= max) {
            max = sxiList.getItemAt(i).xienData;
            maxIndex = i;
        }
    }
    xienCB.selectedIndex = maxIndex;
    
    updateStatus();
    logindex = -1;
    logging();
    stLog[parseInt(lv.text) - 1] = "s";

    w.visible = false;
    application.setFocus();
}

public function statusEdit():void {

    slv.value = parseInt(lv.text);
    ss0.value = parseInt(s0.text);
    ss1.value = parseInt(s1.text);
    ss2.value = parseInt(s2.text);
    ss3.value = parseInt(s3.text);
    ss4.value = parseInt(s4.text);
    ss5.value = parseInt(s5.text);
    ss6.value = parseInt(s6.text);
    ss7.value = parseInt(s7.text);
    ss8.value = parseInt(s8.text);
    ss9.value = parseInt(s9.text);
    //ss10.value = parseInt(s10.text);
    ss11.value = parseInt(s11.text);
    
    var len:Number = xienList.length;
    sxiList = new  ArrayCollection();

    for(var i:Number = 0; i < len; i++) {
        sxiList.addItem({xienLabel: XIEN_NAME[parseInt(xienList.getItemAt(i).data)], xienData: _xi[parseInt(xienList.getItemAt(i).data)]});
    }
    
    w.x = 0;
    w.y = 40;
    w.visible = true;
}

public function replaceText(str:String,oldChar:String,newChar:String):String {
    var strArray:Array = new Array();
    strArray = str.split(oldChar);
    return strArray.join(newChar);
}

public function changeChar(c:Number):void {
    charCB.selectedIndex = c;
    charImg.source = charImgSymbol[c];
    
	var len:Number = STYLE_NAME[c].length;
	styleList = new ArrayCollection();
	
	for(var i:Number = 0; i < len; i++) {
		styleList.addItem({label:STYLE_NAME[c][i], data:i});
	}
	
    styleCB.selectedIndex = 0;
    initXienList(c);
    initXien(c,_style[c]);
    initStatus(c,_style[c],xienCB.selectedIndex);

    application.setFocus();
}
public function changeStyle(s:Number):void {
    
    styleCB.selectedIndex = s;
    initXien(charCB.selectedIndex,s);
    initStatus(charCB.selectedIndex,s,xienCB.selectedIndex);
    
    application.setFocus();
}
public function changeXien(x:Number):void {
    
    var l:Number =  parseInt(lv.text);

    if(MAX_XIEN[charCB.selectedIndex][x].length < l) {
        l = MAX_XIEN[charCB.selectedIndex][x].length;
    }
    if(MAX_XIEN[charCB.selectedIndex][x][l - 1] < _needXien[x]) {
        xienCB.selectedIndex = tmpx;
        application.setFocus();
        return;
    }
    
    for(var l = 0; l < xienList.length; l++) {
        if(xienList.getItemAt(l).data == x) {
            xienCB.selectedIndex = l;
        }
        
    }
    application.setFocus();
}
private function initXien(c:Number,s:Number):void {

    var len:Number = DEFAULT_XIEN[c][s].length;
    for(var i:Number = 0; i < len; i++) {
        _xi[i] = DEFAULT_XIEN[c][s][i];
        
        if(DEFAULT_XIEN[c][s][i] > 0) {
            
            var len2:Number = xienList.length;
            for(var l:Number = 0; l < len2; l++) {
                
                if(xienList.getItemAt(l).label == XIEN_NAME[i]) {
                    xienCB.selectedIndex = l;
                }
            }
        }
    }
}
private function initXienList(c:Number):void  {

    xienList.removeAll();
    
    for(var i:Number = 0; i < MAX_XIEN[c].length; i++) {
        if(MAX_XIEN[c][i][MAX_XIEN[c][i].length -1] > 0) {
            xienList.addItem({label:XIEN_NAME[i], data:i});
        }
    }
}
private function initStatus(c:Number, s:Number, xi:Number):void  {
    
    lv.text = String(1);
	if( c == 15)
	{
		lv.text = String(200);
	}
    s11.text = "0";
    tlvup.text = "0";
    _bonusPoints = 0;
    tbonus.text = "0";
    tmpXien = xi;
    //xienCB.selectedIndex.data;
    
    styleCB.selectedIndex = s;
    xienCB.selectedIndex = xi;
    
    var len:Number = xienList.getItemAt(xi).data;
    for(var i:Number = 0; i < len; i++) {
        _needXien[i] = 2;
    }
    var len2:Number = _needXien.length;
    for(var i:Number = len; i < len2; i++) {
        _needXien[i] = 1;
    }
    len = xienList.length;
    var _color:Array = new Array();
    for(var i:Number = 0; i < len; i++) {
        if(MAX_XIEN[c][xienList.getItemAt(i).data ][0] < _needXien[xienList.getItemAt(i).data]) {
            _color.push(0x000000);

        } else {
            _color.push(0x363636);
        }
    }
    xienCB.setStyle("alternatingItemColors", _color);
    
    s0.text = DEFAULT_STATUS[c][s][0];
    s1.text = DEFAULT_STATUS[c][s][1];
    s2.text = DEFAULT_STATUS[c][s][2];
    s3.text = DEFAULT_STATUS[c][s][3];
    s4.text = DEFAULT_STATUS[c][s][4];
    s5.text = DEFAULT_STATUS[c][s][5];
    s6.text = DEFAULT_STATUS[c][s][6];
    s7.text = DEFAULT_STATUS[c][s][7];
    s8.text = DEFAULT_STATUS[c][s][8];
    s9.text = DEFAULT_STATUS[c][s][9];
    //s10.text = DEFAULT_STATUS[c][s][10];
    
    p0.text = DEFAULT_NEED_POINT[c][s][0];
    p1.text = DEFAULT_NEED_POINT[c][s][1];
    p2.text = DEFAULT_NEED_POINT[c][s][2];
    p3.text = DEFAULT_NEED_POINT[c][s][3];
    p4.text = DEFAULT_NEED_POINT[c][s][4];
    p5.text = DEFAULT_NEED_POINT[c][s][5];
    p6.text = DEFAULT_NEED_POINT[c][s][6];
    
    s0L.data = 25;
    s1L.data = 25;
    s2L.data = 25;
    s3L.data = 25;
    s4L.data = 25;
    s5L.data = 25;
    s6L.data = 25;
    
	s0L.text = "25";
	s1L.text = "25";
	s2L.text = "25";
	s3L.text = "25";
	s4L.text = "25";
	s5L.text = "25";
	s6L.text = "25";
	
    s7mx.text = s7.text;
    s7mi.text = s7.text;
    s8mx.text = s8.text;
    s8mi.text = s8.text;
    s9mx.text = s9.text;
    s9mi.text = s9.text;
    //s10mx.text = s10.text;
    //s10mi.text = s10.text;
    
    s0up.visible = false;
    s1up.visible = false;
    s2up.visible = false;
    s3up.visible = false;
    s4up.visible = false;
    s5up.visible = false;
    s6up.visible = false;
    
    s0dup.visible = true;
    s1dup.visible = true;
    s2dup.visible = true;
    s3dup.visible = true;
    s4dup.visible = true;
    s5dup.visible = true;
    s6dup.visible = true;
	
	pbonus.text = "0%";
    
    _xi[0] = DEFAULT_XIEN[c][s][0];
    _xi[1] = DEFAULT_XIEN[c][s][1];
    _xi[2] = DEFAULT_XIEN[c][s][2];
    _xi[3] = DEFAULT_XIEN[c][s][3];
    _xi[4] = DEFAULT_XIEN[c][s][4];
    _xi[5] = DEFAULT_XIEN[c][s][5];
    _xi[6] = DEFAULT_XIEN[c][s][6];
    _xi[7] = DEFAULT_XIEN[c][s][7];
    _xi[8] = DEFAULT_XIEN[c][s][8];
    _xi[9] = DEFAULT_XIEN[c][s][9];
    _xi[10] = DEFAULT_XIEN[c][s][10];
    _xi[11] = DEFAULT_XIEN[c][s][11];
    _xi[12] = DEFAULT_XIEN[c][s][12];
    _xi[13] = DEFAULT_XIEN[c][s][13];
    _xi[14] = DEFAULT_XIEN[c][s][14];
    _xi[15] = DEFAULT_XIEN[c][s][15];
    _xi[16] = DEFAULT_XIEN[c][s][16];
    _xi[17] = DEFAULT_XIEN[c][s][17];
    _xi[18] = DEFAULT_XIEN[c][s][18];
    _xi[19] = DEFAULT_XIEN[c][s][19];
    _xi[20] = DEFAULT_XIEN[c][s][20];
    _xi[21] = DEFAULT_XIEN[c][s][21];
    _xi[22] = DEFAULT_XIEN[c][s][22];
    _xi[23] = DEFAULT_XIEN[c][s][23];
    _xi[24] = DEFAULT_XIEN[c][s][24];
    _xi[25] = DEFAULT_XIEN[c][s][25];
    _xi[26] = DEFAULT_XIEN[c][s][26];
    _xi[27] = DEFAULT_XIEN[c][s][27];
    _xi[28] = DEFAULT_XIEN[c][s][28];
	_xi[29] = DEFAULT_XIEN[c][s][29];

	_xi[30] = DEFAULT_XIEN[c][s][30];
	_xi[31] = DEFAULT_XIEN[c][s][31];

	_xi[32] = DEFAULT_XIEN[c][s][32];
	_xi[33] = DEFAULT_XIEN[c][s][33];
	_xi[34] = DEFAULT_XIEN[c][s][34];
	
	_xi[35] = DEFAULT_XIEN[c][s][35];
	_xi[36] = DEFAULT_XIEN[c][s][36];
	_xi[37] = DEFAULT_XIEN[c][s][37];
	
	_xi[38] = DEFAULT_XIEN[c][s][38];
	_xi[39] = DEFAULT_XIEN[c][s][39];
	_xi[40] = DEFAULT_XIEN[c][s][40];
	
	_xi[41] = DEFAULT_XIEN[c][s][41];
	_xi[42] = DEFAULT_XIEN[c][s][42];
	_xi[43] = DEFAULT_XIEN[c][s][43];
	
	_xi[44] = DEFAULT_XIEN[c][s][44];
	_xi[45] = DEFAULT_XIEN[c][s][45];
	_xi[46] = DEFAULT_XIEN[c][s][46];
	
	_xi[47] = DEFAULT_XIEN[c][s][47];
	_xi[48] = DEFAULT_XIEN[c][s][48];
	_xi[49] = DEFAULT_XIEN[c][s][49];
	
    tmpBonusExpected = bonusNS.value;

    logindex = -1;
    logging();
    stLog[0] = "";
    tmpStLog[0] = "";
}

public function updateStatus():void {

    var c:Number = charCB.selectedIndex, s:Number = styleCB.selectedIndex,
        dnp:Array = DEFAULT_NEED_POINT[c][s], mxst:Array = MAX_STATUS, mxlv:Number = parseInt(String(MAX_LEVEL));
    
    if(parseInt(tlvup.text) > 0) {
        pbonus.text = (Math.floor(parseInt(tbonus.text) * 1000 / parseInt(tlvup.text)) / 10) + "%";
        
    } else {
        pbonus.text = "0%";
    }
    
    if ( parseInt( s7mi.text ) > MAX_STATUS[7] ) {
        s7mi.text = MAX_STATUS[7];
    }
    if ( parseInt( s7mx.text ) > MAX_STATUS[7] ) {
        s7mx.text = MAX_STATUS[7];
    }
    if ( parseInt( s8mi.text ) > MAX_STATUS[8] ) {
        s8mi.text = MAX_STATUS[8];
    }
    if ( parseInt( s8mx.text ) > MAX_STATUS[8] ) {
        s8mx.text = MAX_STATUS[8];
    }
    if ( parseInt( s9mi.text ) > MAX_STATUS[9] ) {
        s9mi.text = MAX_STATUS[9];
    }
    if ( parseInt( s9mx.text ) > MAX_STATUS[9] ) {
        s9mx.text = MAX_STATUS[9];
    }
	/*
    if ( parseInt( s10mi.text ) > MAX_STATUS[10] ) {
        s10mi.text = MAX_STATUS[10];
    }
    if ( parseInt( s10mx.text ) > MAX_STATUS[10] ) {
        s10mx.text = MAX_STATUS[10];
    }/* */

    p0.text = dnp[0] + Math.floor((parseInt(lv.text) + parseInt(s0.text) * 5) / 125);
    p1.text = dnp[1] + Math.floor((parseInt(lv.text) + parseInt(s1.text) * 5) / 125);
    p2.text = dnp[2] + Math.floor((parseInt(lv.text) + parseInt(s2.text) * 5) / 125);
    p3.text = dnp[3] + Math.floor((parseInt(lv.text) + parseInt(s3.text) * 5) / 125);
    p4.text = dnp[4] + Math.floor((parseInt(lv.text) + parseInt(s4.text) * 5) / 125);
    p5.text = dnp[5] + Math.floor((parseInt(lv.text) + parseInt(s5.text) * 5) / 125);
    p6.text = dnp[6] + Math.floor((parseInt(lv.text) + parseInt(s6.text) * 5) / 125);

    s0L.text = String(Math.ceil(25 - parseInt(lv.text) / 5)  + (parseInt(p0.text) - dnp[0]) *25);
    s1L.text = String(Math.ceil(25 - parseInt(lv.text) / 5)  + (parseInt(p1.text) - dnp[1]) *25);
    s2L.text = String(Math.ceil(25 - parseInt(lv.text) / 5)  + (parseInt(p2.text) - dnp[2]) *25);
    s3L.text = String(Math.ceil(25 - parseInt(lv.text) / 5)  + (parseInt(p3.text) - dnp[3]) *25);
    s4L.text = String(Math.ceil(25 - parseInt(lv.text) / 5)  + (parseInt(p4.text) - dnp[4]) *25);
    s5L.text = String(Math.ceil(25 - parseInt(lv.text) / 5)  + (parseInt(p5.text) - dnp[5]) *25);
    s6L.text = String(Math.ceil(25 - parseInt(lv.text) / 5)  + (parseInt(p6.text) - dnp[6]) *25);
    
    s0up.visible = (parseInt(s0.text) < mxst[0] && parseInt(p0.text) <= parseInt(s11.text));
    s1up.visible = (parseInt(s1.text) < mxst[1] && parseInt(p1.text) <= parseInt(s11.text));
    s2up.visible = (parseInt(s2.text) < mxst[2] && parseInt(p2.text) <= parseInt(s11.text));
    s3up.visible = (parseInt(s3.text) < mxst[3] && parseInt(p3.text) <= parseInt(s11.text));
    s4up.visible = (parseInt(s4.text) < mxst[4] && parseInt(p4.text) <= parseInt(s11.text));
    s5up.visible = (parseInt(s5.text) < mxst[5] && parseInt(p5.text) <= parseInt(s11.text));
    s6up.visible = (parseInt(s6.text) < mxst[6] && parseInt(p6.text) <= parseInt(s11.text));

    s0dup.visible = (parseInt(s0.text) < mxst[0] && (parseInt(lv.text) < mxlv || parseInt(p0.text) <= parseInt(s11.text)));
    s1dup.visible = (parseInt(s1.text) < mxst[1] && (parseInt(lv.text) < mxlv || parseInt(p1.text) <= parseInt(s11.text)));
    s2dup.visible = (parseInt(s2.text) < mxst[2] && (parseInt(lv.text) < mxlv || parseInt(p2.text) <= parseInt(s11.text)));
    s3dup.visible = (parseInt(s3.text) < mxst[3] && (parseInt(lv.text) < mxlv || parseInt(p3.text) <= parseInt(s11.text)));
    s4dup.visible = (parseInt(s4.text) < mxst[4] && (parseInt(lv.text) < mxlv || parseInt(p4.text) <= parseInt(s11.text)));
    s5dup.visible = (parseInt(s5.text) < mxst[5] && (parseInt(lv.text) < mxlv || parseInt(p5.text) <= parseInt(s11.text)));
    s6dup.visible = (parseInt(s6.text) < mxst[6] && (parseInt(lv.text) < mxlv || parseInt(p6.text) <= parseInt(s11.text)));
}
public function upPoints():void {
    var c:Number = charCB.selectedIndex, s:Number = styleCB.selectedIndex,
        dnp:Array = DEFAULT_NEED_POINT[c][s];
    
    p0.text = String(dnp[0] + Math.floor((parseInt(lv.text) + parseInt(s0.text) * 5) / 125));
    p1.text = String(dnp[1] + Math.floor((parseInt(lv.text) + parseInt(s1.text) * 5) / 125));
    p2.text = String(dnp[2] + Math.floor((parseInt(lv.text) + parseInt(s2.text) * 5) / 125));
    p3.text = String(dnp[3] + Math.floor((parseInt(lv.text) + parseInt(s3.text) * 5) / 125));
    p4.text = String(dnp[4] + Math.floor((parseInt(lv.text) + parseInt(s4.text) * 5) / 125));
    p5.text = String(dnp[5] + Math.floor((parseInt(lv.text) + parseInt(s5.text) * 5) / 125));
    p6.text = String(dnp[6] + Math.floor((parseInt(lv.text) + parseInt(s6.text) * 5) / 125));
}

public function lvup():void {
    if(parseInt(lv.text) >= MAX_LEVEL) {
      return;
    }
    lv.text = String(parseInt(lv.text) + 1);
    
    var xien:Number = parseInt(xienCB.selectedItem.data);
    var max:Number = _xi[xien];
    for(var i:Number = 0; i < xien; i++) {
        if(max < _xi[i] ) {
            max = _xi[i];
        }
    }
    var len:Number = _xi.length;
    for(var i:Number = xien + 1; i < len; i++) {
        if(max <= _xi[i]) {
            max = _xi[i] + 1;
        }
    }
    for(var i:Number = 0; i < xien; i++) {
        _needXien[i] = max + 1;
    }
    for(var i:Number = xien; i < len; i++) {
        _needXien[i] = max;
    }
    _xi[xien] = max;
      
      len = xienList.length;
      var _color:Array = new Array();
      var c:Number = charCB.selectedIndex;
      var l:Number;
      
      for(var i:Number = 0; i < len; i++) {
          l =  parseInt(lv.text);
          if(MAX_XIEN[c][xienList.getItemAt(i).data].length < l) {
                l = MAX_XIEN[c][xienList.getItemAt(i).data].length;
          }
          if(MAX_XIEN[c][xienList.getItemAt(i).data][l - 1] < _needXien[xienList.getItemAt(i).data]) {
              _color.push(0x000000);

          } else {
              _color.push(0x363636);
          }
      }
      xienCB.setStyle("alternatingItemColors", _color);
    
    s0.text = parseInt(s0.text ) + XIEN_UP_BONUS[xien][0];
    s1.text = parseInt(s1.text ) + XIEN_UP_BONUS[xien][1];
    s2.text = parseInt(s2.text ) + XIEN_UP_BONUS[xien][2];
    s3.text = parseInt(s3.text ) + XIEN_UP_BONUS[xien][3];

    s4.text = parseInt(s4.text ) + XIEN_UP_BONUS[xien][4];
    s5.text = parseInt(s5.text ) + XIEN_UP_BONUS[xien][5];
    s6.text = parseInt(s6.text ) + XIEN_UP_BONUS[xien][6];
    s7.text = parseInt(s7.text ) + XIEN_UP_BONUS[xien][7];
    s8.text = parseInt(s8.text ) + XIEN_UP_BONUS[xien][8];
    s9.text = parseInt(s9.text ) + XIEN_UP_BONUS[xien][9];
    //s10.text= parseInt(s10.text) + XIEN_UP_BONUS[xien][10];

    s7mi.text  = parseInt(s7mi.text )  + MIN_XIEN_UP_STATUS[xien][0];
    s8mi.text  = parseInt(s8mi.text )  + MIN_XIEN_UP_STATUS[xien][1];
    s9mi.text  = parseInt(s9mi.text )  + MIN_XIEN_UP_STATUS[xien][2];
    //s10mi.text = parseInt(s10mi.text ) + MIN_XIEN_UP_STATUS[xien][3];

    s7mx.text  = parseInt(s7mx.text )  + MAX_XIEN_UP_STATUS[xien][0];
    s8mx.text  = parseInt(s8mx.text )  + MAX_XIEN_UP_STATUS[xien][1];
    s9mx.text  = parseInt(s9mx.text )  + MAX_XIEN_UP_STATUS[xien][2];
    //s10mx.text = parseInt(s10mx.text ) + MAX_XIEN_UP_STATUS[xien][3];
    
    if ( tmpBonusExpected != bonusNS.value ) {
        _bonusPoints = Math.floor((parseInt(lv.text) - 1) * bonusNS.value / 100);
    }
    var bonusExpected:Number = bonusNS.value;
    tlvup.text = String(parseInt(tlvup.text) + 1);
    if ( (_bonusPoints + 1) * 100 <= parseInt(tlvup.text) * bonusExpected || bonusExpected == 100) {
        _bonusPoints++;
        tbonus.text = String(parseInt(tbonus.text) + 1);
        
        s0.text = parseInt(s0.text ) + XIEN_RANDOM_UP_BONUS[xien][0];
        s1.text = parseInt(s1.text ) + XIEN_RANDOM_UP_BONUS[xien][1];
        s2.text = parseInt(s2.text ) + XIEN_RANDOM_UP_BONUS[xien][2];
        s3.text = parseInt(s3.text ) + XIEN_RANDOM_UP_BONUS[xien][3];
        s4.text = parseInt(s4.text ) + XIEN_RANDOM_UP_BONUS[xien][4];
        s5.text = parseInt(s5.text ) + XIEN_RANDOM_UP_BONUS[xien][5];
        s6.text = parseInt(s6.text ) + XIEN_RANDOM_UP_BONUS[xien][6];
    }
    tmpBonusExpected = bonusNS.value;
    
    for ( var i:Number = 0; i < 10; i++) {
        var sArray:Array = [s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,0,s11]; 
        if ( parseInt((sArray[i] as Text).text) > MAX_STATUS[i] ) {
            (sArray[i] as Text).text = MAX_STATUS[i];
        }
    }
    
    s11.text = String(parseInt(s11.text) + BONUS_STATUS_POINT[parseInt(lv.text) - 1]);
    logging();
    stLog[parseInt(lv.text) - 1] = "";
    for ( var l:Number = 0; l < parseInt(lv.text); l++){
        tmpStLog[l] = stLog[l];
    }
    if( logindex > 0 ) {
        var l1:Array = log[logindex], l2:Array = log[logindex - 1];
        l2[1] = l1[1];
        l2[2] = l1[2];
        log[logindex][77] = stLog[parseInt(lv.text) - 1].length;
    }
}
public function stup(s:Number):void {
    var su:Array = STATUS_UP[s];
    var sArray:Array = [s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,0,s11]; 
    var pArray:Array = [p0,p1,p2,p3,p4,p5,p6]; 
    
    if(parseInt((pArray[s] as Text).text) > parseInt(s11.text)) {
        return;
    }
    
    s11.text =  String(parseInt(s11.text) - parseInt((pArray[s] as Text).text));
    (sArray[s] as Text).text = String(parseInt((sArray[s] as Text).text) + 1);

    s7.text  = String(parseInt(s7.text)  + su[0]);
    s8.text  = String(parseInt(s8.text)  + su[1]);
    s9.text  = String(parseInt(s9.text)  + su[2]);
    //s10.text = String(parseInt(s10.text) + su[3]);

    s7mi.text  = String(parseInt(s7mi.text)  + su[0]);
    s8mi.text  = String(parseInt(s8mi.text)  + su[1]);
    s9mi.text  = String(parseInt(s9mi.text)  + su[2]);
    //s10mi.text = String(parseInt(s10mi.text) + su[3]);

    s7mx.text  = String(parseInt(s7mx.text)  + su[0]);
    s8mx.text  = String(parseInt(s8mx.text)  + su[1]);
    s9mx.text  = String(parseInt(s9mx.text)  + su[2]);
    //s10mx.text = String(parseInt(s10mx.text) + su[3]);
    
    for ( var i:Number = 0; i < 10; i++) {
        var sArray:Array = [s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,0,s11]; 
        if ( parseInt((sArray[i] as Text).text) > MAX_STATUS[i] ) {
            (sArray[i] as Text).text = MAX_STATUS[i];
        }
    }

    logging();
    stLogging(String(s));
    
}
public function stdup(n:Number):void {
    var c:Number = charCB.selectedIndex, s:Number = styleCB.selectedIndex,
        len:Number = MAX_STATUS[n],mxlv:Number = MAX_LEVEL, mxst:Number = MAX_STATUS[n];

    var sArray:Array = [s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,0,s11]; 
    var pArray:Array = [p0,p1,p2,p3,p4,p5,p6]; 
    
    var p = Math.floor((parseInt(lv.text) + parseInt((sArray[n] as Text).text) * 5) / 125);
    var pp = p;
    
    while(pp == p && parseInt((sArray[n] as Text).text) < len
            && (parseInt(lv.text) < mxlv || parseInt(s11.text) >= parseInt((pArray[n] as Text).text))) {
            
            while(parseInt(lv.text) < mxlv && parseInt(s11.text) < parseInt((pArray[n] as Text).text)) {
                lvup();
            }
            if(pp == Math.floor((parseInt(lv.text) + parseInt((sArray[n] as Text).text) * 5) / 125)
               && parseInt((sArray[n] as Text).text) < mxst) {
                stup(n);
            }
            p = Math.floor((parseInt(lv.text) + parseInt((sArray[n] as Text).text) * 5) / 125);
    }
}
public function reset():void {
    initXien(charCB.selectedIndex, styleCB.selectedIndex);
    initStatus(charCB.selectedIndex, styleCB.selectedIndex, xienCB.selectedIndex);
};
public function back():void {

    var sl:Array = stLog, l:Number = parseInt(lv.text) - 1;
    
    if(logindex > 0) {
        logindex--;
        
        setLog();
        l = parseInt(lv.text) - 1;
        for(var i:Number = 0; i < l + 2; i++) {
            stLog[i] = tmpStLog[i];
        }
        if(tmpStLog[l].length > log[logindex][77]) {
            stLog[l] = String(stLog[l]).substr(0,parseInt(log[logindex][77]));
        }
        stLog[l + 1] = "";
    }
}
public function dashBack():void {
    
    if(logindex < 1) {
        return;
    }
    
    var sl:Array = stLog, l:Number = parseInt(lv.text) - 1;
    var tmp1:String = log[logindex - 1][1], tmp2:String = log[logindex - 1][2], tmp3:String = "", tmp4:Number = 0;

    for( var i:Number = logindex; i > 0; i--) {

        if(tmpStLog[parseInt(log[i][0]) - 1].length > 0) {
            tmp3 = String(tmpStLog[parseInt(log[i][0]) - 1]).substr(parseInt(log[i][77]) - 1,1)
            tmp4 = Math.floor((parseInt(log[logindex - 1][0]) + parseInt(log[logindex - 1][6 + parseInt(tmp3)]) * 5) / 125);
            break;
        }
    }
    for( var i:Number = logindex ; logindex > 0 && log[logindex - 1][1] == tmp1 && log[logindex - 1][2] == tmp2; logindex--) {
        if(log[logindex][77] > 0 && String(tmpStLog[parseInt(log[logindex][0]) - 1]).substr(parseInt(log[logindex][77]) - 1,1) != tmp3) {
            break;
        }
        if(log[logindex - 1][77] > 0 && Math.floor((parseInt(log[logindex - 1][0]) + parseInt(log[logindex - 1][6 + parseInt(tmp3)]) * 5) / 125) != tmp4) {
            break;
        }
    }
    
    setLog();
    l = parseInt(lv.text) - 1;
    for(var i:Number = 0; i < l + 2; i++) {
       stLog[i] = tmpStLog[i];
    }
    if(tmpStLog[l].length > log[logindex][77]) {
         stLog[l] = String(stLog[l]).substr(0,parseInt(log[logindex][77]));
    }
    stLog[l + 1] = "";
}
public function progress():void {

    var lg:Array = log, sl:Array = stLog, l:Number = parseInt(lv.text) - 1;

    if(lg[logindex + 1][0] > 0) {
        logindex++;
        
        setLog();
        l = parseInt(lv.text) - 1;
        for(var i:Number = 0; i < l + 2; i++) {
            stLog[i] = tmpStLog[i];
        }
        if(tmpStLog[l].length > log[logindex][77]) {
            stLog[l] = String(stLog[l]).substr(0,parseInt(log[logindex][77]));
        }
        stLog[l + 1] = "";
    }
}
public function dashProgress():void {
    
    if(log[logindex + 1][0] < 1) {
        return;
    }
    logindex++;
    
    var sl:Array = stLog, l:Number = parseInt(lv.text) - 1;
    var tmp1:String = log[logindex][1], tmp2:String = log[logindex][2], tmp3:String = "", tmp4:Number = 0;
    
    for( var i:Number = logindex; log[i + 1][0] > 0; i++) {

        if(log[i][77] > 0) {
            tmp3 = String(tmpStLog[parseInt(log[i][0]) - 1]).substr(parseInt(log[i][77]) - 1,1);
            tmp4 = Math.floor((parseInt(log[logindex - 1][0]) + parseInt(log[logindex - 1][6 + parseInt(tmp3)]) * 5) / 125);
            break;
        }
    }
    for( var i:Number = logindex ; log[logindex + 1][0] > 0 && log[logindex][1] == tmp1 && log[logindex][2] == tmp2; logindex++) {
        if(tmp3 != "" && log[logindex + 1][77] > 0 && String(tmpStLog[parseInt(log[logindex + 1][0]) - 1]).substr(parseInt(log[logindex + 1][77]) - 1,1) != tmp3) {
            break;
            
        }
        if(log[logindex][77] > 0 && Math.floor((parseInt(log[logindex][0]) + parseInt(log[logindex][6 + parseInt(tmp3)]) * 5) / 125) != tmp4) {
            break;
        }
    }
    
    setLog();
    l = parseInt(lv.text) - 1;
    for(var i:Number = 0; i < l + 2; i++) {
       stLog[i] = tmpStLog[i];
    }
    if(tmpStLog[l].length > log[logindex][77]) {
         stLog[l] = String(stLog[l]).substr(0,parseInt(log[logindex][77]));
    }
    stLog[l + 1] = "";
}

private function stLogging(s:String):void {
    stLog[parseInt(lv.text) - 1] += s;
    tmpStLog[parseInt(lv.text) - 1] = stLog[parseInt(lv.text) - 1];
    log[logindex][77] = stLog[parseInt(lv.text) - 1].length;
}
private function logging():void {

    var l:Array = log, x:Array = _xi;
    logindex++;
    
    l[logindex] = [parseInt(lv.text),  xienCB.selectedItem.data, bonusNS.value
                ,parseInt(tbonus.text), parseInt(tlvup.text), _bonusPoints
                ,parseInt(s0.text), parseInt(s1.text), parseInt(s2.text), parseInt(s3.text)
                ,parseInt(s4.text), parseInt(s5.text), parseInt(s6.text), parseInt(s7.text)
                ,parseInt(s8.text), parseInt(s9.text), 0, parseInt(s11.text)
                ,parseInt(s7mi.text),parseInt(s8mi.text), parseInt(s9mi.text), 0
                ,parseInt(s7mx.text), parseInt(s8mx.text), parseInt(s9mx.text), 0
                ,x[0], x[1], x[2], x[3], x[4], x[5], x[6], x[7], x[8], x[9], x[10], x[11], x[12], x[13]
                ,x[14], x[15], x[16], x[17], x[18], x[19], x[20], x[21], x[22], x[23], x[24], x[25], x[26], x[27], x[28], x[29]
				,x[30],x[31], x[32],x[33],x[34], x[35],x[36],x[37], x[38],x[39],x[40], x[41],x[42],x[43], x[44],x[45],x[46], x[47],x[48],x[49]
                ,tmpBonusExpected
                ,0
                ];
    
    l[logindex + 1] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0, 1];
    stLog[parseInt(lv.text)] = "";
    tmpStLog[parseInt(lv.text)] = "";
      
}
private function setLog():void {

        var l:Array = log[logindex], x:Array = _xi;

        lv.text = l[0];
        for(var i:Number = 0; i < xienList.length; i++ ) {
            if(xienList.getItemAt(i).data == l[1]) {
                xienCB.selectedIndex = i;
            }
        }
        bonusNS.value = l[2];
        //bind.execute();
        tbonus.text = l[3];
        tlvup.text = l[4];
        _bonusPoints = l[5];
        s0.text = l[6];
        s1.text = l[7];
        s2.text = l[8];
        s3.text = l[9];
        s4.text = l[10];
        s5.text = l[11];
        s6.text = l[12];
        s7.text = l[13];
        s8.text = l[14];
        s9.text = l[15];
        //s10.text = l[16];
        s11.text = l[17];
        s7mi.text = l[18];
        s8mi.text = l[19];
        s9mi.text = l[20];
        //s10mi.text = l[21];
        s7mx.text = l[22];
        s8mx.text = l[23];
        s9mx.text = l[24];
        //s10mx.text = l[25];
        x[0] = l[26];
        x[1] = l[27];
        x[2] = l[28];
        x[3] = l[29];
        x[4] = l[30];
        x[5] = l[31];
        x[6] = l[32];
        x[7] = l[33];
        x[8] = l[34];
        x[9] = l[35];
        x[10] = l[36];
        x[11] = l[37];
        x[12] = l[38];
        x[13] = l[39];
        x[14] = l[40];
        x[15] = l[41];
        x[16] = l[42];
        x[17] = l[43];
        x[18] = l[44];
        x[19] = l[45];
        x[20] = l[46];
        x[21] = l[47];
        x[22] = l[48];
        x[23] = l[49];
        x[24] = l[50];
        x[25] = l[51];
        x[26] = l[52];
        x[27] = l[53];
        x[28] = l[54];
		x[29] = l[55];
		
		x[30] = l[56];
		x[31] = l[57];
		
		x[32] = l[58];
		x[33] = l[59];
		x[34] = l[60];
		
		x[35] = l[61];
		x[36] = l[62];
		x[37] = l[63];
		
		x[38] = l[64];
		x[39] = l[65];
		x[40] = l[66];
		
		x[41] = l[67];
		x[42] = l[68];
		x[43] = l[69];
		
		x[44] = l[70];
		x[45] = l[71];
		x[46] = l[72];
		
		x[47] = l[73];
		x[48] = l[74];
		x[49] = l[75];
		
        tmpBonusExpected = l[76];
}

public function logOut():void {

    var c:Number = charCB.selectedIndex;
    var s:Number = styleCB.selectedIndex;
    var l:Array = log;
    var lis:Number = 0;
    var lie:Number = 0;
    var sl:Array = stLog;
    var logtxt:String = "";
    var gokuburi:Boolean = false;
    var gokuburiSt:Number = -1;
    var gokuburiCnt:Number = 0;
    var summry:Boolean = false;
    var pattern:String  = "-";
    var startLv:Number = 0;
    var bonusXienTXT:String = "";
    var len:Number = 0;
    var min:Number = 1;
	if (c == 15)
	{
		min = 200;
	}
    
    if((String(sl[l[0][0] - 1]).substr(0,1)) == "s") {
        var a:Array= l[0];
        logtxt += "Status       : " + a.join(", ") + "\r";
        min = l[0][0];
    } else
    if(sl[0] == undefined || String(sl[0]).length == 0) {
        logtxt += "LV ";
        
        if(l[0][0] < 100) {
          logtxt += " ";
        }
        if(l[0][0] < 10) {
          logtxt += " ";
        }
        logtxt += l[0][0] + "       :\r";
        logtxt += "Bonus        : " + l[0][2] + "%\r";
        logtxt += "Xien         : " + XIEN_NAME[l[0][1]] + "\r";
    }
    
    len = parseInt(lv.text);
    for(var i:Number = min; i < len; i++) {
        var plis:Number = lis;
        lie++;
        lis = lie;
        var len2:Number = l.length;
		try
		{
        while(len2 > lie + 1 && l[lie + 1][0] == i  + 1) {
            lie++;
        }
        bonusXienTXT = "";
        if(i != 1 && l[lis][0] != 0 && l[lis - 1][2] != l[plis - 1][2]) {
            bonusXienTXT += "Bonus        : " + l[lis - 1][2] + "%\r";
        }
        if(i != 1  && l[lis][0] != 0 && l[lis - 1][1] != l[plis - 1][1]) {
            bonusXienTXT += "Xien         : " + XIEN_NAME[l[lis - 1][1]] + "\r";
        }/* */
		}catch(e:Error)
		{
		}

        var bonusXienFlag:Boolean = false;
        if(plis > 0) {
            bonusXienFlag = ((l[plis - 1][1] != l[lis - 1][1]) || (l[plis - 1][2] != l[lis - 1][2])) && (l[lis][0] != 0);
        }
        var cnt:Number = 0;
        var renzoku:Boolean = true;
        len2 = String(sl[i]).length;
        
        for(var m:Number = 0; m < len2 ; m++) {
            if( String(sl[i]).substr(m,1) != String(sl[i]).substr(0,1)) {
                renzoku = false;
                break;
            }
            cnt++;
        }
        if(gokuburi) {
            
            if(renzoku && (len2 == 0 || gokuburiSt == parseInt(String(sl[i]).substr(0,1))) && bonusXienFlag == false
               && parseInt(l[lie][17]) < Math.floor((parseInt(l[lie][6 + gokuburiSt]) * 5 + i + 1) / 125 + parseInt(DEFAULT_NEED_POINT[c][s][gokuburiSt]))) {
                gokuburiCnt += cnt;
                continue;
                
            } else {
                gokuburi = false;
                
                logtxt += "LV ";
                if(startLv < 100) {
                    logtxt += " ";
                }
                if(startLv < 10) {
                    logtxt += " ";
                }
                logtxt += String(startLv);
                if(startLv == i) {
                    logtxt += "       : ";
                
                } else {
                    logtxt += " - ";
                    
                    if(i < 100) {
                        logtxt += " ";
                    }
                    if(i < 10) {
                        logtxt += " ";
                    }
                    logtxt += i + " : "
                }
                logtxt += STATUS_NAME[gokuburiSt] + " 極振り " + gokuburiCnt + "up\r" + bonusXienTXT;
            }
        }
        if(summry) {
            if(pattern == String(sl[i]) && bonusXienFlag == false) {
                continue;
            
            } else {
                summry = false;

                logtxt += "LV ";
                if(startLv < 100) {
                    logtxt += " ";
                }
                if(startLv < 10) {
                    logtxt += " ";
                }
                logtxt += String(startLv);
                if(startLv == i) {
                    logtxt += "       : ";
                
                } else {
                    logtxt += " - ";
                    
                    if(i < 100) {
                        logtxt += " ";
                    }
                    if(i < 10) {
                        logtxt += " ";
                    }
                    logtxt += i + " : "
                }
                var summrySt:Number = parseInt(pattern.substr(0,1));
                var summryCnt:Number = 0;
                len2 = pattern.length;
                for(var m:Number = 0; m < len2; m++) {
                    
                    if(STATUS_NAME[summrySt] == undefined) {
                        summrySt = parseInt(pattern.substr(m + 1,1));
                        continue;
                    }
                    
                    if(summrySt == parseInt(pattern.substr(m,1))) {
                        summryCnt++;
                        
                    } else {
                        logtxt += STATUS_NAME[summrySt];
                        
                        if(summryCnt > 1) {
                            logtxt += " * " + summryCnt;
                        }
                        summryCnt = 1;
                        logtxt += ", ";
                        summrySt = parseInt(pattern.substr(m,1));
                    }
                    if(m == len2 - 1) {
                        logtxt += STATUS_NAME[summrySt];
                        
                        if(summryCnt > 1) {
                            
                            logtxt += " * " + summryCnt;
                        }
                    }
                }
                logtxt += "\r" + bonusXienTXT;
                pattern = "-";
            }
        }
        gokuburiSt = parseInt(String(sl[i]).substr(0,1));
        if(renzoku
           && parseInt(l[lie][17]) < Math.floor((parseInt(l[lie][6 + gokuburiSt]) * 5 + i + 1) / 125 + parseInt(DEFAULT_NEED_POINT[c][s][gokuburiSt]))) {
           
           gokuburi = true;
           summry = false;
           gokuburiCnt = cnt;
           startLv = i + 1;
           continue;
        
        } else {
            summry = true;
            pattern = sl[i];
            startLv = i + 1;
            
        }/**/
    }

    if(gokuburi) {
        
        logtxt += "LV ";
        if(startLv < 100) {
            logtxt += " ";
        }
        if(startLv < 10) {
            logtxt += " ";
        }
        logtxt += String(startLv);
        if(startLv == i) {
            logtxt += "       : ";
        
        } else {
            logtxt += " - ";
            
            if(i < 100) {
                logtxt += " ";
            }
            if(i < 10) {
                logtxt += " ";
            }
            logtxt += i + " : "
        }
        logtxt += STATUS_NAME[gokuburiSt] + " 極振り " + gokuburiCnt + "up\r";
    }
    if(summry) {

        logtxt += "LV ";
        if(startLv < 100) {
            logtxt += " ";
        }
        if(startLv < 10) {
            logtxt += " ";
        }
        logtxt += String(startLv);
        if(startLv == i) {
            logtxt += "       : ";
        
        } else {
            logtxt += " - ";
            
            if(i < 100) {
                logtxt += " ";
            }
            if(i < 10) {
                logtxt += " ";
            }
            logtxt += i + " : "
        }
        var summrySt:Number = parseInt(pattern.substr(0,1));
        var summryCnt:Number = 0;
        len = pattern.length;
        for(var m:Number = 0; m < len; m++) {
            
            if(STATUS_NAME[summrySt] == undefined) {
                summrySt = parseInt(pattern.substr(m + 1,1));
                continue;
            }
            
            if(summrySt == parseInt(pattern.substr(m,1))) {
                summryCnt++;
                
            } else {
                logtxt += STATUS_NAME[summrySt];
                
                if(summryCnt > 1) {
                    logtxt += " * " + summryCnt;
                }
                summryCnt = 1;
                logtxt += ", ";
                summrySt = parseInt(pattern.substr(m,1));
            }
            if(m == len - 1) {
                logtxt += STATUS_NAME[summrySt];
                
                if(summryCnt > 1) {
                    
                    logtxt += " * " + summryCnt;
                }
            }
        }
        logtxt += "\r";
    }
    /* */
    
    logtxt += charCB.selectedItem.label + "/" + styleCB.selectedItem.label;
    logtxt += " Bonus: " + tbonus.text + " / " + tlvup.text + " Point: " + s11.text + "\r";
    logtxt += "LV:" + lv.text  + " STAB " + s0.text + " HACK " + s1.text + " INT " + s2.text;
    logtxt += " DEF " + s3.text + " MR " + s4.text;
    logtxt += " DEX " + s5.text + " AGI " + s6.text;
    
    logarea.text = logtxt;
    callLater( function():void {
       logarea.verticalScrollPosition = logarea.maxVerticalScrollPosition;
    });
}
public function logLoad():void {
    var logorg:String = replaceText(replaceText(replaceText(logarea.text,"，",","),"：",":"),"－","-");
    var logtxt:Array = new Array();
    var line:Number = 0;
    var len:Number = 0;
    var charName:Array = CHAR_NAME;
    
    logtxt[line] = "";
    len = logorg.length;
    for(var i:Number = 0; i < len; i++) {
        
        if(logorg.substr(i, 1) == "\r") {
            line++;
            logtxt[line] = "";
            while(i + 1 < len && logorg.substr(i + 1, 1) == " ") {
                i++;
            }
            continue;
            
        } else {
            logtxt[line] += logorg.substr(i, 1);
        }
        while(i + 1 < len  && logorg.substr(i, 1) == " " && logorg.substr(i + 1, 1) == " " ) {
            i++;
        }
    }
    
    len = logtxt.length;
    var len2:Number = charName.length;
    for(var i:Number = 0; i < len; i++) {
        var str:String = replaceText(logtxt[i], " ","");
        var token:Array = str.split("/");
        
        
        for(var l:Number = 0; l < len2; l++) {
            
            if(String(token[0]) == charName[l]) {
                changeChar(l);
                
                if(String(token[1]).substr(0,String(STYLE_NAME[l][0]).length) == STYLE_NAME[l][0]) {
                    changeStyle(0);
                    i = logtxt.length;
                    break;
                }
                if(String(token[1]).substr(0,String(STYLE_NAME[l][1]).length) == STYLE_NAME[l][1]) {
                    changeStyle(1);
                    i = logtxt.length;
                    break;
                }
                if(String(token[1]).substr(0,String(STYLE_NAME[l][2]).length) == STYLE_NAME[l][2]) {
                    changeStyle(2);
                    i = logtxt.length;
                    break;
                }
                i = logtxt.length;
                break;
            }
        }
    }
    //return;
    
    for(var i:Number = 0; i < logtxt.length; i++) {
        var logline:String = String(logtxt[i]);
        var token:Array = logline.split(":");
        var tag:String = token[0];
        
        if(tag == "undefined" && tag == "") {
            continue;
        }
        
        if(tag.split(" ")[0] == "LV") {
            
            var index:Number = 3;
            var num:String = "";
            var startLv:Number = undefined;
            var endLv:Number = undefined;
            
            num = tag.split(" ")[1];
            if(isNaN(parseInt(num)) == false) {
                startLv = parseInt(num);
                endLv = startLv;
            }
            num = tag.split(" ")[3];
            if(isNaN(parseInt(num)) == false) {
                endLv = parseInt(num);
            }
            var st:Array = new Array();
            var stindex:Number = 0;
            
            var token2:Array = String(token[1]).split(",");
            len = token2.length;
            
            for(var l:Number = 0; l < len; l++) {
                
                if(String(token2[l]).substr(0,1) != " ") {
                    token2[l] = " " + token2[l];
                }
                var token3:Array = String(token2[l]).split(" ");
    
                for(var m:Number = 0; m < 7; m++) {
                    
                    if(token3[1] == STATUS_NAME[m]) {
                        st[stindex] = m;
                        
                        if(token3.length > 2 && token3[2] == "極振り") {
                            for(var n:Number = startLv; n < endLv + 1; n++) {
                                lvup();
                                upPoints();
                                
                                var sArray:Array = [s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,0,s11]; 
                                var pArray:Array = [p0,p1,p2,p3,p4,p5,p6];
                                 
                                while(parseInt((sArray[m] as Text).text) < MAX_STATUS[m]
                                        && parseInt(s11.text) >= parseInt((pArray[m] as Text).text)) {
                                    
                                    stup(m);
                                    upPoints();
                                    
                                }
                            }
                            startLv = endLv + 1;
                            l = token2.length;
                            break;
                        }
                        
                        if(token3.length > 3 && token3[2] == "*") {
                            num = token3[3];
                            if(isNaN(parseInt(num)) == false) {
                                for(var n:Number = 1; n < parseInt(num); n++) {
                                    stindex++;
                                    st[stindex] = m;
                                }
                            }
                        }
                        stindex++;
                        break;
                    }
                }
                
            }
            for(var l:Number = startLv; l < endLv + 1; l++) {
                
                if( l == 1) {
                    continue;
                }
                
                if( l != log[0][0]) {
                    lvup();
                }
                upPoints();
                
                for(var m:Number = 0; m < stindex; m++) {
                    stup(parseInt(st[m]));
                    upPoints();
                }
            }
        }
        if(tag.split(" ")[0] == "Bonus") {
            
            var num:String = replaceText(String(token[1]).split(" ")[1],"%","");
            if(isNaN(parseInt(num)) == false) {
                bonusNS.value = parseInt(num);
            }
        }
        if(tag.split(" ")[0] == "Xien") {

            var xa:Array = String(token[1]).split(" ");
            var x:String = xa[1] + " " + xa[2];
            var len:Number = XIEN_NAME.length;
            
            for(var l:Number = 0; l < len; l++) {
                if(x == XIEN_NAME[l]) {
                    changeXien(l);
                }
            }
        }
        if(tag.split(" ")[0] == "Status") {
            
            var a:Array = replaceText(String(token[1])," ","").split(",");
            if(a.length == 46) {
                logindex = 0;
                var len:Number = a.length;
                var la:Array = log[logindex];
                for(var l = 0; l < len; l++ ) {
                    la[l] = parseInt(a[l]);
                }
                stLog[a[0] - 1] = "s";
                tmpStLog[a[0] - 1] = "s";
                setLog();
            }
        }
    }
    logOut();
}
public function recipe():void {
    var l:Array = log, sl:Array = stLog, rtxt:String = "", lis:Number = 0, lie:Number = 0,
        plis:Number = 0, renzoku:Boolean = false, st:Number = -1, len:Number = 0, bonusXien:String = "",
        bonusXienFlag:Boolean = false, bonusLv:Number = 2;
    
    rtxt = "■ステータス\r";
    rtxt += "【キャラ】";
    rtxt += charCB.selectedItem.label;
    rtxt += "\r【タイプ】";
    rtxt += styleCB.selectedItem.label;
    rtxt += "\r【 LV 　】 ";
    rtxt += lv.text;
    rtxt += "\r【STAB】 ";
    rtxt += s0.text;
    rtxt += "\r【HACK】 ";
    rtxt += s1.text;
    rtxt += "\r【 INT　】 ";
    rtxt += s2.text;
    rtxt += "\r【 DEF 】 ";
    rtxt += s3.text;
    rtxt += "\r【 MR　】 ";
    rtxt += s4.text;
    rtxt += "\r【 DEX 】 ";
    rtxt += s5.text;
    rtxt += "\r【 AGI　】 ";
    rtxt += s6.text;
    rtxt += "\r【 H P　】 ";
    rtxt += s7.text;
    rtxt += "\r【 M P　】 ";
    rtxt += s8.text;
    rtxt += "\r【 S P　】 ";
    rtxt += s9.text;
	/*
    rtxt += "\r【WEIGHT】 ";
    rtxt += s10.text;/* */
    rtxt += "\rボーナス ";
    rtxt += pbonus.text;
    rtxt += "\r";
    rtxt += "\r【 兜　】 ";
    rtxt += "\r【武器】 ";
    rtxt += "\r【 鎧　】 ";
    rtxt += "\r【 盾　】 ";
    rtxt += "\r【 頭　】 ";
    rtxt += "\r【背中】 ";
    rtxt += "\r【 手　】 ";
    rtxt += "\r【 脚　】 ";
    rtxt += "\r【ペット】 ";
    rtxt += "\r【狩場 】 ";
    rtxt += "\r";
    rtxt += "\r";
    rtxt += "\r■再振りレシピ\r";
    
    len = parseInt(lv.text);
    st = parseInt(String(sl[1]).substr(0,1));
    
    var min:Number = 1;
    if(String(sl[l[0][0] - 1]).substr(0,1) == "s") {
        var a:Array = l[0];
        rtxt += "開始ステータス{ " + l[0].join(", ") + " }\r";
        min = l[0][0] -1;
        st = parseInt(String(sl[min]).substr(1,1));
    }
    
    for(var i:Number = min; i < len; i++) {
        
        if(l[lie + 1][0] == 0) {
            break;
        }
        
        plis = lis;
        lis = lie + 1;
        lie = lis;
        while(lie < l.length - 1 && l[lie][0] == l[lie + 1][0]) {
            lie++;
        }

        //bonusXienFlag = false;
        if(lis == 1 || l[lis - 1][2] != l[plis - 1][2] || l[lis - 1][1] != l[plis - 1][1]) {
            bonusXienFlag = true;
            bonusXien += "Lv " + l[lis][0] + " から ";
            bonusLv = l[lis][0];
            
            if(lis == 1 || l[lis - 1][2] != l[plis - 1][2]) {
                bonusXien += "ボーナス " + l[lis - 1][2] + "%"
            }
            if(lis == 1 || l[lis - 1][1] != l[plis - 1][1]) {
                bonusXien += " " + XIEN_NAME[l[lis - 1][1]] + "先行"
            }
            bonusXien += "\r";
            
            if(lis == 1) {
                rtxt += bonusXien;
                bonusXienFlag = false;
                bonusXien = "";
            }
        }
        var sll:String = replaceText( String(sl[i]), "s", "");
        var len2:Number = sll.length;
        for(var m:Number = 0; m < len2; m++) {
            
            if(bonusXienFlag && bonusLv <=l[lis + m - 1][0]) {
               rtxt += bonusXien;
               bonusXien = "";
               bonusXienFlag = false;
            }
            if(isNaN(st) == false && (sll.substr(m,1) != String(st) || bonusXienFlag )) {
                
                var lvupFlag:Number = 0;
                if(l[lis + m][0] == l[lis + m - 1][0] + 1) {
                    lvupFlag = 1;
                }
                rtxt += STATUS_NAME[st] + " " + l[lis + m - lvupFlag][6 + st];
                if(m == 0 && sll.substr(m,1) != String(st)) {
                    rtxt += ", Lv  " + l[lis + m - 1][0];
                }
                if(Math.floor((l[lis + m][6 + st] * 5 + l[lis + m][0]) /125)
                   - Math.floor((l[lis + m - 1 - lvupFlag][6 + st] * 5 + l[lis + m - 1 - lvupFlag][0]) /125) > 0) {
                    
                    var num:Number = (DEFAULT_NEED_POINT[charCB.selectedIndex][styleCB.selectedIndex][st]
                                               + Math.floor((l[lis + m][6 + st] * 5 +l[lis + m][0]) /125));
                    
                    rtxt += ", 必要Point " + num;
                }
                rtxt += " まで " + STATUS_NAME[st] + " に振る\r" + bonusXien;
                bonusXien = "";
                bonusXienFlag = false;
            }
            st = parseInt(sll.substr(m,1));
        }
    }
    
    if(m == undefined) {
      m = 0;
    }
    lis += m + 1;
    if(bonusXienFlag && bonusLv <= l[lis - 1][0]) {
       rtxt += bonusXien;
       bonusXien = "";
       bonusXienFlag = false;
    }
    if(st != undefined && isNaN(st) == false) {

        var lvupFlag:Number = 0;
        if(l[lis - 1][0] == l[lis - 2][0] + 1) {
               lvupFlag = 1;
        }
        if( l[lis][6 + st] == 0) {
             l[lis][6 + st] =  l[lis - 1][6 + st];
        }
        
        rtxt += STATUS_NAME[st] + " " + l[lis - lvupFlag][6 + st];
        if((DEFAULT_NEED_POINT[charCB.selectedIndex][styleCB.selectedIndex][st]
                                       + Math.floor((l[lis - 1][6 + st] * 5 +l[lis - 1][0]) /125)) > l[lis - 1 - lvupFlag][17]) {
            rtxt += ", Lv  " + l[lis - 1 - lvupFlag][0];
        }
        if(Math.floor((l[lis - 1][6 + st] * 5 + l[lis - 1][0]) /125)
           - Math.floor((l[lis - 2 - lvupFlag][6 + st] * 5 + l[lis - 2 - lvupFlag][0]) /125) > 0) {
            
            var num:Number = (DEFAULT_NEED_POINT[charCB.selectedIndex][styleCB.selectedIndex][st]
                                       + Math.floor((l[lis - 1][6 + st] * 5 +l[lis - 1][0]) /125));
            
            rtxt += ", 必要Point " + num;
        }
        rtxt += " まで " + STATUS_NAME[st] + " に振る\r" + bonusXien;

    } else {
       rtxt += bonusXien;

    }
    rtxt += "\r\r■再振りログ\r";
    
    logOut();
    logarea.text = rtxt + logarea.text;
    callLater( function():void {
        logarea.verticalScrollPosition = 0;
    });
}
