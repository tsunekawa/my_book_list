
/********************
 * main.js          *
 ********************/

$(function (){

    $('.book-register-form').on('submit', function (event){
      event.preventDefault();
      var form = $(event.target);

      $.post('/book', $(this).serialize(), function (event){
	if (event.status=="success") {
	  form.find('.alert').text(event.message).addClass('alert-success');
	}else{
	  form.find('.alert').text(event.message).addClass('alert-error');
	}

        return false;
      });

      return false;
    });

    $('.book-deleter-form').on('submit', function (event){
      event.preventDefault();
      var form = $(event.target);

      $.post(form.attr('action'), $(this).serialize(), function (event){
	if (event.status=="success") {
	  form.find('.alert').text(event.message).addClass('alert-success');
	}else{
	  form.find('.alert').text(event.message).addClass('alert-error');
	}

        return false;
      });

      return false;
    });

});
