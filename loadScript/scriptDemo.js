/**
 * 方差
 * @demo variance(1,2,3,4,6,6)
 * @param {number} x1~xn n个数据
 * @return {number} 返回 n个数据的方差
 */
function variance(){
    var n=arguments.length,s=0,ave=average([].slice.apply(arguments));
    for(var i=0;i<n;i++){
        s+=Math.pow(arguments[i]-ave,2);
    }
    return s/n;
}

/**
 * 样本方差
 * @demo spVariance(1,2,3,4,6,6)
 * @param {number} x1~xn n个数据
 * @return {number} 返回n个数据的样本方差
 */
function spVariance(){
    var n=arguments.length,s=0,ave=average([].slice.apply(arguments));
    for(var i=0;i<n;i++){
        s+=Math.pow(arguments[i]-ave,2);
    }
    return s/(n-1);
}

/**
 * 标准化残差
 * @demo stdResidual(x1,y1,x2,y2...xn,yn)
 * @param {string} flag 可选标记
 * @param {number} x1~xn n对计算数据
 * @return {number} 返回n个数据对的标准化残差
 */
function stdResidual(){
    var len=arguments.length,
        n=len/2,s=0,SSE=0,arrX=[],arrY=[],arrZRESID=[],arrSyy=[],arrH=[],arrYHat=[],
        aveX,aveY,b0,b1,yHat,h,syy,ZRESID,
        sumxy=0,sumxx=0,   //sum((xi-aveX)(yi-aveY)),sum((xi-aveX)^2)
        re='';

    //push xi~xn in arrX, yi~yn in arrY
    for(var i=0; i<len; ){
        arrX.push(arguments[i++]);
        arrY.push(arguments[i++]);
    }
    aveX=average(arrX);
    aveY=average(arrY);

    for(var i=0,xi_avex,yi_avey; i<n; i++){
        xi_avex=arrX[i]-aveX;   //xi-aveX
        yi_avey=arrY[i]-aveY;   //yi-aveY
        sumxy+=xi_avex*yi_avey;
        sumxx+=xi_avex*xi_avex;
    }
    b1=sumxy/sumxx;
    b0=aveY-b1*aveX;
    yHat=function(i){return b0+b1*arrX[i];}
    
    for(var i=0; i<n; i++){
        SSE+=Math.pow(arrY[i]-yHat(i),2);
    }

    s=Math.sqrt(SSE/(n-2));
    h=function(i){return 1/n+(Math.pow(arrX[i]-aveX,2)/sumxx);}
    syy=function(i){return s*Math.sqrt(1-h(i));}
    ZRESID=function(i){return (arrY[i]-yHat(i))/syy(i);}
    
    for(var i=0; i<n; i++){
        arrZRESID.push(ZRESID(i).toFixed(6));
        arrSyy.push(syy(i).toFixed(6));
        arrH.push(h(i).toFixed(6));
        arrYHat.push(yHat(i).toFixed(6));
    }
    re+='ZRESID:'+arrZRESID+'\n';
    re+='Syi-y^i:'+arrSyy+'\n';
    re+='hi:'+arrH+'\n';
    re+='y^i:'+arrYHat+'\n';
    re+='s:'+s+'\n';
    re+='b0:'+b0+'\n';
    re+='b1:'+b1+'\n';
    return re;
}

/**
 * 平均值
 * @demo average(1,2,3,4,6,6) 或 average([1,2,3,4,6,6])
 * @param {number|array} x1~xn n个数据
 * @return {number} 返回n个数据的平均值
 */
function average(){
    if(arguments[0] instanceof Array){
        return eval(arguments[0].join('+'))/arguments[0].length;
    }else{
        return eval([].slice.apply(arguments).join('+'))/arguments.length;
    }
}

/**
 * 输出一组步进数字
 * @demo stepNum(init,count,step)
 * @param {number} init  开始数字
 * @param {number} count 输出个数
 * @param {number} step  步长
 * @return {array} 返回一组数字
 */
function stepNum(){
    var arr   = [],
        init  = arguments[0]||1,
        count = arguments[1]||10,
        step  = arguments[2]||1;

    while(count--){
        arr.push(init);
        init+=step;
    }
    return arr;
}

/**
 * 返回一个随机数
 * @demo roll(10)
 * @param {number}
 * @return {number} 返回0~n之间的一个随机整数
 */
function roll(){
    return Math.round(Math.random()*(arguments[0]||100));
}


//返回当前日期
function date(){
    return (new Date()).toLocaleDateString();
}


//返回当前时间
function time(){
    return (new Date()).toLocaleTimeString();
}

//返回当前日期和时间
function dateTime(){
    return (new Date()).toLocaleString();
}

//--------------String.prototype--------------
var sp=String.prototype;

/**
 * 变量声明对齐
 * @param {string} param0 对齐参考符号，默认是'='
 * @param {bool} param1 是否对名称按长短排序，默认是false
 * @return {string} 返回排列后的字符串
 */
sp.alignment   = function(){
    var arr    = this.replace(/\n$/,'').split('\n'),
        sign   = arguments[0]||'=',
        sort   = arguments[1]||false,    //sort by name?
        regex  = new RegExp(sign+'\\s*');

    //sort by the length of variable name
    var arr2 = arr.slice(0).sort(function(a,b){
            return a.indexOf(sign) - b.indexOf(sign);
        }),
        eqIndex = arr2[arr2.length-1].indexOf(sign);

    if(sort)arr=arr2;

    arr.forEach(function(item,i){
        var iIndex=item.indexOf(sign),
            s=Array(eqIndex-iIndex+2).join(' ');
        arr[i]=item.replace(regex,s+sign+' ');
    })
    return arr.join('\n');
}

/**
 * 重复n次字符串
 * @param {number} 重复次数，默认2 
 * @return {string}
 */
sp.repeat = function(){
    return Array((arguments[0]||2)+1).join(this);
}