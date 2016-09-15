$(document).ready(function () {
    $(".sidebar-menu a").each(function (num, ele) {
        if (location.href === ele.href)
            $(ele).addClass("sidebar-menu-current")
    });
    var time = 0;
    $(".panel").hide();
    $(".panel").each(function (num, ele) {
        setTimeout(function () {
            $(ele).show()
                  .addClass('animated bounceInUp')
                  .one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function () {
                    $(ele).removeClass('animated bounceInUp');
                  });
        }.bind(this), time);
        time += 200;
    });
});