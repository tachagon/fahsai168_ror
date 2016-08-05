var init_material = function () {
  $.material.init();
  $.material.ripples();
  $.material.input();
  $.material.checkbox();
  $.material.radio();
}

var init_tooltip = function () {
  $('[data-toggle="tooltip"]').tooltip();
}
