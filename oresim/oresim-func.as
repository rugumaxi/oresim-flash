
/**
 * 型
 */
var _style:Array = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ];

var _needXien:Array = [ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 ];

var xi:Array = [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ];

var bonusPoints = 0;

var stLog:Array = new Array(MAX_LEVEL);
var stackLog = "";
var log:Array = new Array(MAX_LEVEL * 4);
var logindex = 0;
var focusLogarea = false;
var tmpXien = 0;
var tmpBonusExpected = 50;

var src = new EndPoint();
src.component = _root.bonusNS;
src.property = "value";
src.event = "change";

var dest = new EndPoint();
dest.component = _root.bonusTXT;
dest.property = "text";

var bonusBind:Binding
= new Binding(src, dest, {cls: mx.data.formatters.ComposeString, settings: {template: "<..> %"}}, false);

if(ExternalInterface.call("getClipboard") == undefined) {
    pasteB.enabled = false;
    pasteB._visible = false;
}

var se = new Sound();
se.setVolume(35);
var so:SharedObject = SharedObject.getLocal("soundVolume");
if(so.data.volume != undefined) {
    _root.vol.tumami._x = so.data.volume;
    se.setVolume((so.data.volume -16) * 100 / 108);
}

var characterCBLis:Object = new Object();
characterCBLis.change = function(eObj:Object) {
    _root.cImg.gotoAndStop("c" + eObj.target.selectedItem.data);
    changeChar(eObj.target.selectedItem.data);
}
characterCB.addEventListener("change",characterCBLis);

var styleCBLis:Object = new Object();
styleCBLis.change = function(eObj:Object) {
    changeStyle(eObj.target.selectedItem.data);
}
styleCB.addEventListener("change",styleCBLis);

xienCB.dropdown.changeHandler
  = function(obj:Object) {
    var c:Number = _root.characterCB.selectedIndex;
    var xi:Number =  _root.xienList.getItemAt(this.selectedIndex).data;
    var l:Number = parseInt(_root.lv.value);
    if(MAX_XIEN[c][xi].length < l) {
        l = MAX_XIEN[c][xi].length;
    }
    
    if ( _root.MAX_XIEN[c][xi][l - 1] >= _root._needXien[xi]) {
        var o = this.owner; // 'this' is the dropdown; 'o' is the combobox
        var prevValue = o.selectedIndex;
        obj.target = o;

        if (this == this.owner.text_mc)
        {
            o.selectedIndex = undefined;
            o.dispatchChangeEvent(obj,-1,-2); // Force a change event to be dispatched
        }
        else
        {
            o.selectedIndex = this.selectedIndex;
             if (!o._showingDropdown)
             {
                 o.dispatchChangeEvent(obj,prevValue, o.selectedIndex);
             } else if (!o.bInKeyDown) {
                o.displayDropdown(false);
                 
             }
        }
    } else {
        var o = this.owner; // 'this' is the dropdown; 'o' is the combobox
        o.displayDropdown(false);
    }
}

onEnterFrame = function() {
    if(focusLogarea && Key.isDown(Key.ESCAPE)) {
        Selection.setFocus(null);
    }
}

fscommand("trapallkeys","true");
var keyListener:Object = new Object();
keyListener.onKeyDown = function() {
    if(focusLogarea == false) {
        if(Key.getCode() == 76) {
            lvupPress();
        }
        if(Key.getCode() == 83) {
            stupPress(0);
        }
        if(Key.getCode() == 72) {
            stupPress(1);
        }
        if(Key.getCode() == 73) {
            stupPress(2);
        }
        if(Key.getCode() == 70) {
            stupPress(3);
        }
        if(Key.getCode() == 77) {
            stupPress(4);
        }
        if(Key.getCode() == 88) {
            stupPress(5);
        }
        if(Key.getCode() == 65) {
            stupPress(6);
        }
        if(Key.getCode() == 37) {
            backPress();
        }
        if(Key.getCode() == 39) {
            progressPress(6);
        }
        if(Key.getCode() == 71) {
            guidePress();
        }
        if(Key.getCode() == 80) {
            logLoadPress();
        }
        if(Key.getCode() == 84) {
            statusEdit();
        }
        if(Key.getCode() ==  13) {
            var txt:String = logarea.text;
           Selection.setFocus("_root.logarea");
           Selection.setSelection(0,0);
           logarea,text = txt;
        }
    
    }

    //trace(Key.getCode());
};
Key.addListener(keyListener);

lvupB.onPress = function() {
    _root.lvupPress();
};
backB.onPress = function() {
    _root.backPress();
};
progressB.onPress = function() {
    _root.progressPress();
};
guideB.onPress = function() {
    guidePress();
};
resetB.onPress = function() {
    initXien(characterCB.selectedIndex, styleCB.selectedIndex);
    initStatus(characterCB.selectedIndex, styleCB.selectedIndex, xienCB.selectedIndex);
    updateStatus();
};

s0up.onPress = function() {
    stupPress(0);
};
s1up.onPress = function() {
    stupPress(1);
};
s2up.onPress = function() {
    stupPress(2);
};
s3up.onPress = function() {
    stupPress(3);
};
s4up.onPress = function() {
    stupPress(4);
};
s5up.onPress = function() {
    stupPress(5);
};
s6up.onPress = function() {
    stupPress(6);
};

s0dup.onPress = function() {
    stdupPress(0);
};
s1dup.onPress = function() {
    stdupPress(1);
};
s2dup.onPress = function() {
    stdupPress(2);
};
s3dup.onPress = function() {
    stdupPress(3);
};
s4dup.onPress = function() {
    stdupPress(4);
};
s5dup.onPress = function() {
    stdupPress(5);
};
s6dup.onPress = function() {
    stdupPress(6);
};

pasteB.onPress = function() {
    logarea.text = String(replaceText(ExternalInterface.call("getClipboard"),"\r\n","\r"));
};
loadB.onPress = function() {
    _root.logLoadPress();
};
copyB.onPress = function() {
    System.setClipboard(replaceText(logarea.text,"\r","\r\n"));
};
clearB.onPress = function() {
    logarea.text = "";
};
function lvupPress() {
       if(parseInt(lv.value) < MAX_LEVEL) {
          _root.se1.gotoAndPlay("play");
          lvup();
          logOut();
          updateStatus();
       }
}
function stupPress(n:Number) {
      if(parseInt(s11.value) >= parseInt(eval("p" + n + ".value"))) {
          _root.se2.gotoAndPlay("play");
          stup(n);
          logOut();
          updateStatus();
      }
}
function stdupPress(n:Number) {
      if(parseInt(eval("s" + n + ".value")) < MAX_STATUS[n]) {
          _root.se2.gotoAndPlay("play");
          stdup(n);
          logOut();
          updateStatus();
      }
}
function backPress() {
    back();
    updateStatus();
}
function progressPress() {
    progress();
    updateStatus();
}
function logLoadPress() {
    logLoad();
    updateStatus();
}
function guidePress() {
    if(logindex > 0 ) {
        recipe();
    }
}



function replaceText(str,oldChar,newChar) {
    var strArray = new Array();
    strArray = str.split(oldChar);
    return strArray.join(newChar);
}

function lvup() {
    if(lv.value >= MAX_LEVEL) {
      return;
    }
    lv.value++;
    
    var xien:Number = parseInt(xienCB.selectedItem.data);
    var max:Number = xi[xien];
    for(var i:Number = 0; i < xien; i++) {
        if(max < xi[i] ) {
            max = xi[i];
        }
    }
    var len:Number = xi.length;
    for(var i:Number = xien + 1; i < len; i++) {
        if(max <= xi[i]) {
            max = xi[i] + 1;
        }
    }
    for(var i:Number = 0; i < xien; i++) {
        _needXien[i] = max + 1;
    }
    for(var i:Number = xien; i < len; i++) {
        _needXien[i] = max;
    }
    xi[xien] = max;
      
      len = xienCB.length;
      var _color:Array = new Array(len);
      var c:Number = charCB.selectedIndex;
      var l:Number;
      
      for(var i:Number = 0; i < len; i++) {
          l =  parseInt(lv.value);
          if(MAX_XIEN[c][xienList.getItemAt(i).data].length < l) {
                l = MAX_XIEN[c][xienList.getItemAt(i).data].length;
          }
          if(MAX_XIEN[c][xienList.getItemAt(i).data][l - 1] < _needXien[xienList.getItemAt(i).data]) {
              _color[i] = 0xCCCCD8;

          } else {
              _color[i] = 0x6860A8;
          }
      }
      xienCB.dropdown.setStyle("alternatingRowColors", _color);
    
    s0.value = parseInt(s0.value ) + XIEN_UP_BONUS[xien][0];
    s1.value = parseInt(s1.value ) + XIEN_UP_BONUS[xien][1];
    s2.value = parseInt(s2.value ) + XIEN_UP_BONUS[xien][2];
    s3.value = parseInt(s3.value ) + XIEN_UP_BONUS[xien][3];

    s4.value = parseInt(s4.value ) + XIEN_UP_BONUS[xien][4];
    s5.value = parseInt(s5.value ) + XIEN_UP_BONUS[xien][5];
    s6.value = parseInt(s6.value ) + XIEN_UP_BONUS[xien][6];
    s7.value = parseInt(s7.value ) + XIEN_UP_BONUS[xien][7];
    s8.value = parseInt(s8.value ) + XIEN_UP_BONUS[xien][8];
    s9.value = parseInt(s9.value ) + XIEN_UP_BONUS[xien][9];
    s10.value= parseInt(s10.value) + XIEN_UP_BONUS[xien][10];

    s7mi.value  = parseInt(s7mi.value )  + MIN_XIEN_UP_STATUS[xien][0];
    s8mi.value  = parseInt(s8mi.value )  + MIN_XIEN_UP_STATUS[xien][1];
    s9mi.value  = parseInt(s9mi.value )  + MIN_XIEN_UP_STATUS[xien][2];
    s10mi.value = parseInt(s10mi.value ) + MIN_XIEN_UP_STATUS[xien][3];

    s7mx.value  = parseInt(s7mx.value )  + MAX_XIEN_UP_STATUS[xien][0];
    s8mx.value  = parseInt(s8mx.value )  + MAX_XIEN_UP_STATUS[xien][1];
    s9mx.value  = parseInt(s9mx.value )  + MAX_XIEN_UP_STATUS[xien][2];
    s10mx.value = parseInt(s10mx.value ) + MAX_XIEN_UP_STATUS[xien][3];
    
    var oldbs:Number = log[logindex][2];
    if ( parseInt(bonusNS.value) != oldbs) {
        bonusPoints = Math.floor((parseInt(lv.value) - 2) * parseInt(bonusNS.value) / 100);
    }
    bonusExpected = parseInt(bonusNS.value);
    tlvup.value = parseInt(tlvup.value) + 1;
    if ( (bonusPoints + 1) * 100 <= parseInt(tlvup.value) * bonusExpected) {
        bonusPoints++;
        tbonus.value = parseInt(tbonus.value) + 1;
        
        s0.value = parseInt(s0.value ) + XIEN_RANDOM_UP_BONUS[xien][0];
        s1.value = parseInt(s1.value ) + XIEN_RANDOM_UP_BONUS[xien][1];
        s2.value = parseInt(s2.value ) + XIEN_RANDOM_UP_BONUS[xien][2];
        s3.value = parseInt(s3.value ) + XIEN_RANDOM_UP_BONUS[xien][3];
        s4.value = parseInt(s4.value ) + XIEN_RANDOM_UP_BONUS[xien][4];
        s5.value = parseInt(s5.value ) + XIEN_RANDOM_UP_BONUS[xien][5];
        s6.value = parseInt(s6.value ) + XIEN_RANDOM_UP_BONUS[xien][6];
    }
    tmpBonusExpected = parseInt(bonusNS.value);
    
    for ( var i:Number = 0; i < 10; i++) {
        if ( eval("s" + i + ".value") > MAX_STATUS[i] ) {
            set("s" + i + ".value", MAX_STATUS[i]);
        }
    }
    
    s11.value = parseInt(s11.value) + BONUS_STATUS_POINT[lv.value - 1];
    
    logging();
    /*
    if( logindex > 0 ) {
        var l:Array = log[logindex], l2:Array = log[logindex - 1];
        l2[1] = l[1];
        l2[2] = l[2];
    }/* */
    stLog[parseInt(lv.value) - 1] = "";
}
function stup(s:Number) {
    var su:Array = STATUS_UP[s];
    
    if(parseInt(eval("p" + s + ".value")) > parseInt(s11.value)) {
        return;
    }
    
    s11.value =  parseInt(s11.value) - parseInt(eval("p" + s + ".value"));
    set("s" + s + ".value", parseInt(eval("s" + s + ".value")) + 1);

    s7.value  = parseInt(s7.value)  + su[0];
    s8.value  = parseInt(s8.value)  + su[1];
    s9.value  = parseInt(s9.value)  + su[2];
    s10.value = parseInt(s10.value) + su[3];

    s7mi.value  = parseInt(s7mi.value)  + su[0];
    s8mi.value  = parseInt(s8mi.value)  + su[1];
    s9mi.value  = parseInt(s9mi.value)  + su[2];
    s10mi.value = parseInt(s10mi.value) + su[3];

    s7mx.value  = parseInt(s7mx.value)  + su[0];
    s8mx.value  = parseInt(s8mx.value)  + su[1];
    s9mx.value  = parseInt(s9mx.value)  + su[2];
    s10mx.value = parseInt(s10mx.value) + su[3];
    
    logging();
    stLog[parseInt(lv.value) - 1] += String(s);
}
function stdup(n:Number) {
    var c:Number = charCB.selectedIndex, s:Number = styleCB.selectedIndex,
        len:Number = MAX_STATUS[n], sv:String = "s" + n + ".value", sp:String = "p" + n + ".value",
        mxlv:Number = MAX_LEVEL, mxst:Number = MAX_STATUS[n];
    
    p = Math.floor((parseInt(lv.value) + parseInt(eval("s" + n + ".value")) * 5) / 125);
    pp = p;
    
    while(pp == p && parseInt(eval(sv)) < len
            && (parseInt(lv.value) < mxlv || parseInt(s11.value) >= parseInt(eval(sp)))) {
            
            while(parseInt(lv.value) < mxlv && parseInt(s11.value) < parseInt(eval(sp))) {
                lvup();
            }
            if(pp == Math.floor((parseInt(lv.value) + parseInt(eval(sv)) * 5) / 125)
               && parseInt(eval(sv)) < mxst) {
                stup(n);
            }
            p = Math.floor((parseInt(lv.value) + parseInt(eval(sv)) * 5) / 125);
    }
}
function upPoints() {
    var c:Number = charCB.selectedIndex, s:Number = styleCB.selectedIndex,
        dnp:Array = DEFAULT_NEED_POINT[c][s];
    
    p0.value = dnp[0] + Math.floor((parseInt(lv.value) + parseInt(s0.value) * 5) / 125);
    p1.value = dnp[1] + Math.floor((parseInt(lv.value) + parseInt(s1.value) * 5) / 125);
    p2.value = dnp[2] + Math.floor((parseInt(lv.value) + parseInt(s2.value) * 5) / 125);
    p3.value = dnp[3] + Math.floor((parseInt(lv.value) + parseInt(s3.value) * 5) / 125);
    p4.value = dnp[4] + Math.floor((parseInt(lv.value) + parseInt(s4.value) * 5) / 125);
    p5.value = dnp[5] + Math.floor((parseInt(lv.value) + parseInt(s5.value) * 5) / 125);
    p6.value = dnp[6] + Math.floor((parseInt(lv.value) + parseInt(s6.value) * 5) / 125);
}
function updateStatus() {
    var c:Number = charCB.selectedIndex, s:Number = styleCB.selectedIndex,
        dnp:Array = DEFAULT_NEED_POINT[c][s], mxst:Array = MAX_STATUS, mxlv:Number = parseInt(MAX_LEVEL);
    
    if(parseInt(tlvup.value) > 0) {
        pbonus.value = (Math.floor(parseInt(tbonus.value) * 1000 / parseInt(tlvup.value)) / 10) + "%";
        
    } else {
        pbonus.value = "0%";
    }
    
    p0.value = dnp[0] + Math.floor((parseInt(lv.value) + parseInt(s0.value) * 5) / 125);
    p1.value = dnp[1] + Math.floor((parseInt(lv.value) + parseInt(s1.value) * 5) / 125);
    p2.value = dnp[2] + Math.floor((parseInt(lv.value) + parseInt(s2.value) * 5) / 125);
    p3.value = dnp[3] + Math.floor((parseInt(lv.value) + parseInt(s3.value) * 5) / 125);
    p4.value = dnp[4] + Math.floor((parseInt(lv.value) + parseInt(s4.value) * 5) / 125);
    p5.value = dnp[5] + Math.floor((parseInt(lv.value) + parseInt(s5.value) * 5) / 125);
    p6.value = dnp[6] + Math.floor((parseInt(lv.value) + parseInt(s6.value) * 5) / 125);

    s0L.value = Math.ceil(25 - parseInt(lv.value) / 5)  + (parseInt(p0.value) - dnp[0]) *25;
    s1L.value = Math.ceil(25 - parseInt(lv.value) / 5)  + (parseInt(p1.value) - dnp[1]) *25;
    s2L.value = Math.ceil(25 - parseInt(lv.value) / 5)  + (parseInt(p2.value) - dnp[2]) *25;
    s3L.value = Math.ceil(25 - parseInt(lv.value) / 5)  + (parseInt(p3.value) - dnp[3]) *25;
    s4L.value = Math.ceil(25 - parseInt(lv.value) / 5)  + (parseInt(p4.value) - dnp[4]) *25;
    s5L.value = Math.ceil(25 - parseInt(lv.value) / 5)  + (parseInt(p5.value) - dnp[5]) *25;
    s6L.value = Math.ceil(25 - parseInt(lv.value) / 5)  + (parseInt(p6.value) - dnp[6]) *25;
    
    s0up._visible = (parseInt(s0.value) < mxst[0] && parseInt(p0.value) <= parseInt(s11.value));
    s1up._visible = (parseInt(s1.value) < mxst[1] && parseInt(p1.value) <= parseInt(s11.value));
    s2up._visible = (parseInt(s2.value) < mxst[2] && parseInt(p2.value) <= parseInt(s11.value));
    s3up._visible = (parseInt(s3.value) < mxst[3] && parseInt(p3.value) <= parseInt(s11.value));
    s4up._visible = (parseInt(s4.value) < mxst[4] && parseInt(p4.value) <= parseInt(s11.value));
    s5up._visible = (parseInt(s5.value) < mxst[5] && parseInt(p5.value) <= parseInt(s11.value));
    s6up._visible = (parseInt(s6.value) < mxst[6] && parseInt(p6.value) <= parseInt(s11.value));

    s0dup._visible = (parseInt(s0.value) < mxst[0] && (parseInt(lv.value) < mxlv || parseInt(p0.value) <= parseInt(s11.value)));
    s1dup._visible = (parseInt(s1.value) < mxst[1] && (parseInt(lv.value) < mxlv || parseInt(p1.value) <= parseInt(s11.value)));
    s2dup._visible = (parseInt(s2.value) < mxst[2] && (parseInt(lv.value) < mxlv || parseInt(p2.value) <= parseInt(s11.value)));
    s3dup._visible = (parseInt(s3.value) < mxst[3] && (parseInt(lv.value) < mxlv || parseInt(p3.value) <= parseInt(s11.value)));
    s4dup._visible = (parseInt(s4.value) < mxst[4] && (parseInt(lv.value) < mxlv || parseInt(p4.value) <= parseInt(s11.value)));
    s5dup._visible = (parseInt(s5.value) < mxst[5] && (parseInt(lv.value) < mxlv || parseInt(p5.value) <= parseInt(s11.value)));
    s6dup._visible = (parseInt(s6.value) < mxst[6] && (parseInt(lv.value) < mxlv || parseInt(p6.value) <= parseInt(s11.value)));
}
function changeChar(c:Number) {
    
    charCB.selectedIndex = c;
    styleCB.removeAll();
    styleCB.addItem({data:0, label:STYLE_NAME[c][0]});
    styleCB.addItem({data:1, label:STYLE_NAME[c][1]});
    styleCB.addItem({data:2, label:STYLE_NAME[c][2]});
    styleCB.selectedIndex = 0;
    initXienList(c);
    initXien(c,_style[c]);
    initStatus(c,_style[c],xienCB.selectedIndex);
}
function changeStyle(s:Number) {
    
    styleCB.selectedIndex = s;
    initXien(charCB.selectedIndex,s);
    initStatus(charCB.selectedIndex,s,xienCB.selectedIndex);
}
function changeXien(x:Number) {
    
    for(l = 0; l < xienCB.length; l++) {
        if(xienList.getItemAt(l).data == x) {
            xienCB.selectedIndex = l;
        }
    }
}
function initXienList(c:Number) {
    xienCB.removeAll();
    for(var i:Number = 0; i < MAX_XIEN[c].length; i++) {
        if(MAX_XIEN[c][i][MAX_XIEN[c][i].length -1] > 0) {
            xienCB.addItem({data:i, label:XIEN_NAME[i]});
        }
    }
}
function initXien(c:Number,s:Number) {

    var len:Number = DEFAULT_XIEN[c][s].length;
    for(var i:Number = 0; i < len; i++) {
        xi[i] = DEFAULT_XIEN[c][s][i];
        
        if(DEFAULT_XIEN[c][s][i] > 0) {
            
            var len2:Number = xienCB.length;
            for(l = 0; l < len2; l++) {
                if(xienList.getItemAt(l).label == XIEN_NAME[i]) {
                    xienCB.selectedIndex = l;
                }
            }
        }
    }
}

function stLogging(s:String) {
    stLog[parseInt(lv.value) - 1] += s;
}
function logging() {

    var l:Array = log, x:Array = xi;
    logindex++;
    
    l[logindex] = [parseInt(lv.value),  parseInt(xienCB.selectedItem.data), parseInt(bonusNS.value)
                ,parseInt(tbonus.value), parseInt(tlvup.value), bonusPoints
                ,parseInt(s0.value), parseInt(s1.value), parseInt(s2.value), parseInt(s3.value)
                ,parseInt(s4.value), parseInt(s5.value), parseInt(s6.value), parseInt(s7.value)
                ,parseInt(s8.value), parseInt(s9.value), parseInt(s10.value), parseInt(s11.value)
                ,parseInt(s7mi.value),parseInt(s8mi.value), parseInt(s9mi.value), parseInt(s10mi.value)
                ,parseInt(s7mx.value), parseInt(s8mx.value), parseInt(s9mx.value), parseInt(s10mx.value)
                ,x[0], x[1], x[2], x[3], x[4], x[5], x[6], x[7], x[8], x[9], x[10], x[11], x[12], x[13], x[14], x[15], x[16], x[17], x[18], x[19]
                ];
    
    l[logindex + 1] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    stLog[parseInt(lv.value)] = "";   
}
function back() {

    var sl:Array = stLog, l:Number = 0;
    /*
    if(logindex > 0) {
        logindex--;
        
        l = parseInt(lv.value) - 1;
        setLog();
        if(log[logindex][0] == log[logindex + 1][0]) {
            stackLog = String(stLog[l]).substr(-1,1) + stackLog; 
            stLog[l] = String(sl[l]).substr(0, String(sl[l]).length -1);
        }
    }
    trace("test");*/
    
}
function progress() {

    var lg:Array = log, sl:Array = stLog, l:Number = parseInt(lv.value) - 1;

    if(lg[logindex + 1][0] > 0) {
        logindex++;
        
        setLog();
        if(lg[logindex][0] != lg[logindex - 1][0]) {
            sl[l] = String(sl[l]) + String(stackLog).substr(0,1);
            stackLog = String(stackLog).substr(1,stackLog.length -1);
        }
    }
}
function setLog() {

        var bind = bonusBind, l:Array = log[logindex], x:Array = xi;

        lv.value = l[0];
        for(var i:Number = 0; i < xienCB.length; i++ ) {
            if(xienList.getItemAt(i).data == l[1]) {
                xienCB.selectedIndex = i;
            }
        }
        bonusNS.value = l[2];
        bind.execute();
        tbonus.value = l[3];
        tlvup.value = l[4];
        bonusPoints = l[5];
        s0.value = l[6];
        s1.value = l[7];
        s2.value = l[8];
        s3.value = l[9];
        s4.value = l[10];
        s5.value = l[11];
        s6.value = l[12];
        s7.value = l[13];
        s8.value = l[14];
        s9.value = l[15];
        s10.value = l[16];
        s11.value = l[17];
        s7mi.value = l[18];
        s8mi.value = l[19];
        s9mi.value = l[20];
        s10mi.value = l[21];
        s7mx.value = l[22];
        s8mx.value = l[23];
        s9mx.value = l[24];
        s10mx.value = l[25];
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
}
function logOut() {

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
    
    if(String(sl[l[0][0] - 1]).substr(0,1) == "s") {
        var a:Array= l[0];
        logtxt += "Status       : " + a.join(", ") + "\r";
        min = l[0][0] - 1;
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
    
    len = parseInt(lv.value);
    for(var i:Number = min; i < len; i++) {
        
        
        var plis:Number = lis;
        lie++;
        lis = lie;
        var len2:Number = l.length;
        while(len2 > lie + 1 && l[lie + 1][0] == i  + 1) {
            lie++;
        }
        bonusXienTXT = "";
        if(i != 1 && l[lis][0] != 0 && l[lis - 1][2] != l[plis - 1][2]) {
            bonusXienTXT += "Bonus        : " + l[lis - 1][2] + "%\r";
        }
        if(i != 1  && l[lis][0] != 0 && l[lis - 1][1] != l[plis - 1][1]) {
            bonusXienTXT += "Xien         : " + XIEN_NAME[l[lis - 1][1]] + "\r";
        }
        var bonusXienFlag:Boolean = (l[plis - 1][1] != l[lis - 1][1] || l[plis - 1][2] != l[lis - 1][2]) && l[lis][0] != 0;
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
            
        }
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
    
    logtxt += charCB.selectedItem.label + "/" + styleCB.selectedItem.label;
    logtxt += " Bonus: " + tbonus.value + " / " + tlvup.value + " Point: " + s11.value + "\r";
    logtxt += "LV:" + lv.value  + " STAB " + s0.value + " HACK " + s1.value + " INT " + s2.value;
    logtxt += " DEF " + s3.value + " MR " + s4.value;
    logtxt += " DEX " + s5.value + " AGI " + s6.value;
    
    logarea.text = logtxt;
    callLater( function():void {
       logarea.verticalScrollPosition = logarea.maxVerticalScrollPosition;
    });
}
function logLoad() {
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
                _root.cImg.gotoAndStop("c" +l);
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
            if(isNaN(num) == false) {
                startLv = parseInt(num);
                endLv = startLv;
            }
            num = tag.split(" ")[3];
            if(isNaN(num) == false) {
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
                                
                                while(parseInt(eval("s" + m + ".value")) < MAX_STATUS[m]
                                        && parseInt(s11.value) >= parseInt(eval("p" + m + ".value"))) {
                                    
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
                            if(isNaN(num) == false) {
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
            if(isNaN(num) == false) {
                bonusNS.value = parseInt(num);
                bonusBind.execute();
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
                setLog();
            }
        }
    }
    logOut();
}
function recipe() {
    var l:Array = log, sl:Array = stLog, rtxt:String = "", lis:Number = 0, lie:Number = 0,
        plis:Number = 0, renzoku:Boolean = false, st:Number = -1, len:Number = 0, bonusXien:String = "",
        bonusXienFlag:Boolean = false, bonusLv:Number = 2;
    
    rtxt = "■ステータス\r";
    rtxt += "【キャラ】";
    rtxt += charCB.selectedItem.label;
    rtxt += "\r【タイプ】";
    rtxt += styleCB.selectedItem.label;
    rtxt += "\r【 LV 　】 ";
    rtxt += lv.value;
    rtxt += "\r【STAB】 ";
    rtxt += s0.value;
    rtxt += "\r【HACK】 ";
    rtxt += s1.value;
    rtxt += "\r【 INT　】 ";
    rtxt += s2.value;
    rtxt += "\r【 DEF 】 ";
    rtxt += s3.value;
    rtxt += "\r【 MR　】 ";
    rtxt += s4.value;
    rtxt += "\r【 DEX 】 ";
    rtxt += s5.value;
    rtxt += "\r【 AGI　】 ";
    rtxt += s6.value;
    rtxt += "\r【 H P　】 ";
    rtxt += s7.value;
    rtxt += "\r【 M P　】 ";
    rtxt += s8.value;
    rtxt += "\r【 S P　】 ";
    rtxt += s9.value;
    rtxt += "\r【WEIGHT】 ";
    rtxt += s10.value;
    rtxt += "\rボーナス ";
    rtxt += pbonus.value;
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
    
    len = parseInt(lv.value);
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
                
                rtxt += STATUS_NAME[st] + " " + l[lis + m][6 + st];
                if(m == 0 && sll.substr(m,1) != String(st)) {
                    rtxt += ", Lv  " + l[lis + m - 1][0];
                }
                if(Math.floor((l[lis + m][6 + st] * 5 + l[lis + m][0]) /125)
                   - Math.floor((l[lis + m - 1][6 + st] * 5 + l[lis + m - 1][0]) /125) > 0) {
                    
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
    lis += m;
    if(bonusXienFlag && bonusLv <= l[lis - 1][0]) {
       rtxt += bonusXien;
       bonusXien = "";
       bonusXienFlag = false;
    }
    if(st != undefined && isNaN(st) == false) {

        if( l[lis][6 + st] == 0) {
             l[lis][6 + st] =  l[lis - 1][6 + st];
        }
        
        rtxt += STATUS_NAME[st] + " " + l[lis][6 + st];
        if(m == 0) {
            rtxt += ", Lv  " + l[lis -1][0];
        }
        if(Math.floor((l[lis][6 + st] * 5 + l[lis][0]) /125)
           - Math.floor((l[lis - 1][6 + st] * 5 + l[lis - 1][0]) /125) > 0) {
            
            var num:Number = (DEFAULT_NEED_POINT[charCB.selectedIndex][styleCB.selectedIndex][st]
                                       + Math.floor((l[lis][6 + st] * 5 +l[lis][0]) /125));
            
            rtxt += ", 必要Point " + num;
        }
        rtxt += " まで " + STATUS_NAME[st] + " に振る\r" + bonusXien;

    } else {
       rtxt += bonusXien;

    }
    rtxt += "\r\r■再振りログ\r";
    
    logOut();
    logarea.text = rtxt + logarea.text;
    logarea.verticalPosition = 0;
}
function statusEdit() {
    var w:Object = sw;
    
    w.content.slv.value = parseInt(_root.lv.value);
    w.content.ss0.value = parseInt(_root.s0.value);
    w.content.ss1.value = parseInt(_root.s1.value);
    w.content.ss2.value = parseInt(_root.s2.value);
    w.content.ss3.value = parseInt(_root.s3.value);
    w.content.ss4.value = parseInt(_root.s4.value);
    w.content.ss5.value = parseInt(_root.s5.value);
    w.content.ss6.value = parseInt(_root.s6.value);
    w.content.ss7.value = parseInt(_root.s7.value);
    w.content.ss8.value = parseInt(_root.s8.value);
    w.content.ss9.value = parseInt(_root.s9.value);
    w.content.ss10.value = parseInt(_root.s10.value);
    w.content.ss11.value = parseInt(_root.s11.value);
    
    w.content.commitB.onPress = function() {

    lv.value = _root.sw.content.slv.value;
    
    s0.value = _root.sw.content.ss0.value;
    s1.value = _root.sw.content.ss1.value;
    s2.value = _root.sw.content.ss2.value;
    s3.value = _root.sw.content.ss3.value;
    s4.value = _root.sw.content.ss4.value;
    s5.value = _root.sw.content.ss5.value;
    s6.value = _root.sw.content.ss6.value;
    s7.value = _root.sw.content.ss7.value;
    s8.value = _root.sw.content.ss8.value;
    s9.value = _root.sw.content.ss9.value;
    s10.value = _root.sw.content.ss10.value;
    s11.value = _root.sw.content.ss11.value;
    
    s7mx.value = _root.sw.content.ss7.value;
    s7mi.value = _root.sw.content.ss7.value;
    s8mx.value = _root.sw.content.ss8.value;
    s8mi.value = _root.sw.content.ss8.value;
    s9mx.value = _root.sw.content.ss9.value;
    s9mi.value = _root.sw.content.ss9.value;
    s10mx.value = _root.sw.content.ss10.value;
    s10mi.value = _root.sw.content.ss10.value;
    
    var len:Number = xienCB.length, x:Array = xi, max:Number = 0, maxIndex:Number = 0;
    
    for(var i:Number = 0; i < len; i++) {
        x[parseInt(xienList.getItemAt(i).data)] = parseInt(_root.sw.content.sxi.getItemAt(i).data);
        if(_root.sw.content.sxi.getItemAt(i).data >= max) {
            max = _root.sw.content.sxi.getItemAt(i).data;
            maxIndex = i;
        }
    }
    xienCB.selectedIndex = maxIndex;
    
    _root.updateStatus();
    _root.logindex = -1;
    _root.logging();
    _root.stLog[parseInt(lv.value) - 1] = "s";

    _root.sw._visible = false;
    };

    w.content.sxi.hScrollPolicy = "off";
    w.content.sxi.showHeaders = false;
    
    var len:Number = xienCB.length, sa:Array = new  Array();
    w.content.sxi.dataProvider = sa;

    for(var i:Number = 0; i < len; i++) {
        sa.addItem({label: XIEN_NAME[parseInt(xienList.getItemAt(i).data)], data: xi[parseInt(xienList.getItemAt(i).data)]});
    }
    w.content.sxi.getColumnAt(0).editable = false;
    w.content.sxi.getColumnAt(1).width = 48;
    
    w.verticalPosition = 0;
    w._visible = true;
    //statusDialog._visible = true;
}
function initStatus(c:Number, s:Number, xi:Number) {
    
    lv.value= 1;
	if(c == 15) {
		lv.value = 200;
	}
    s11.value = 0;
    tlvup.value = 0;
    bonusPoints = 0;
    tbonus.value = 0;
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
    len = xienCB.length;
    var _color:Array = new Array(len);
    for(var i:Number = 0; i < len; i++) {
        if(MAX_XIEN[c][xienList.getItemAt(i).data][0] < _needXien[xienList.getItemAt(i).data]) {
            _color[i] = 0xCCCCD8;

        } else {
            _color[i] = 0x6860A8;
        }
    }
    xienCB.dropdown.setStyle("alternatingRowColors", _color);

    
    s0.value = DEFAULT_STATUS[c][s][0];
    s1.value = DEFAULT_STATUS[c][s][1];
    s2.value = DEFAULT_STATUS[c][s][2];
    s3.value = DEFAULT_STATUS[c][s][3];
    s4.value = DEFAULT_STATUS[c][s][4];
    s5.value = DEFAULT_STATUS[c][s][5];
    s6.value = DEFAULT_STATUS[c][s][6];
    s7.value = DEFAULT_STATUS[c][s][7];
    s8.value = DEFAULT_STATUS[c][s][8];
    s9.value = DEFAULT_STATUS[c][s][9];
    s10.value = DEFAULT_STATUS[c][s][10];
    
    p0.value = DEFAULT_NEED_POINT[c][s][0];
    p1.value = DEFAULT_NEED_POINT[c][s][1];
    p2.value = DEFAULT_NEED_POINT[c][s][2];
    p3.value = DEFAULT_NEED_POINT[c][s][3];
    p4.value = DEFAULT_NEED_POINT[c][s][4];
    p5.value = DEFAULT_NEED_POINT[c][s][5];
    p6.value = DEFAULT_NEED_POINT[c][s][6];
    
    s0L.value = 25;
    s1L.value = 25;
    s2L.value = 25;
    s3L.value = 25;
    s4L.value = 25;
    s5L.value = 25;
    s6L.value = 25;
    
    s7mx.value = s7.value;
    s7mi.value = s7.value;
    s8mx.value = s8.value;
    s8mi.value = s8.value;
    s9mx.value = s9.value;
    s9mi.value = s9.value;
    s10mx.value = s10.value;
    s10mi.value = s10.value;
    
    s0up._visible = false;
    s1up._visible = false;
    s2up._visible = false;
    s3up._visible = false;
    s4up._visible = false;
    s5up._visible = false;
    s6up._visible = false;
    
    s0dup._visible = true;
    s1dup._visible = true;
    s2dup._visible = true;
    s3dup._visible = true;
    s4dup._visible = true;
    s5dup._visible = true;
    s6dup._visible = true;
    
    xi[0] = DEFAULT_XIEN[c][s][0];
    xi[1] = DEFAULT_XIEN[c][s][1];
    xi[2] = DEFAULT_XIEN[c][s][2];
    xi[3] = DEFAULT_XIEN[c][s][3];
    xi[4] = DEFAULT_XIEN[c][s][4];
    xi[5] = DEFAULT_XIEN[c][s][5];
    xi[6] = DEFAULT_XIEN[c][s][6];
    xi[7] = DEFAULT_XIEN[c][s][7];
    xi[8] = DEFAULT_XIEN[c][s][8];
    xi[9] = DEFAULT_XIEN[c][s][9];
    xi[10] = DEFAULT_XIEN[c][s][10];
    xi[11] = DEFAULT_XIEN[c][s][11];
    xi[12] = DEFAULT_XIEN[c][s][12];
    xi[13] = DEFAULT_XIEN[c][s][13];
    xi[14] = DEFAULT_XIEN[c][s][14];
    xi[15] = DEFAULT_XIEN[c][s][15];
    xi[16] = DEFAULT_XIEN[c][s][16];
    xi[17] = DEFAULT_XIEN[c][s][17];
    xi[18] = DEFAULT_XIEN[c][s][18];
    xi[19] = DEFAULT_XIEN[c][s][19];
    
    logindex = -1;
    logging();
    stLog[0] = "";
}
