window.uid = Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 5);

$(window).on("blur focus",function(){
    Cookies.set(window.uid + '_window_active', new Date, { expires: 600 });
});

browserIsActive = function(){
    var time = Cookies.get(window.uid + '_window_active');
    if(!time){
        return false;
    }else{
        time = new Date(time);
        if((new Date() - time) > 300000){
            return false;
        }else{
            return true;
        }
    }
};