$(document).ready(function () {

    $(".sidebar-menu a").each(function (num, ele) {
        if (location.href === ele.href)
            $(ele).addClass("sidebar-menu-current")
    });


});