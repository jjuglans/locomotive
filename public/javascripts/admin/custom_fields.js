$(document).ready(function() {
	
	$('fieldset.fields').parents('form').submit(function() {
		$('fieldset.fields li.template input, fieldset.fields li.template select').attr('disabled', 'disabled');
	});
	
	var defaultValue = $('fieldset.fields li.template input[type=text]').val();
	var selectOnChange = function(select) {
		select.hide();
		select.prev()
			.show()
			.html(select[0].options[select[0].options.selectedIndex].text);
	}
	
	var refreshPosition = function() {
		jQuery.each($('fieldset.fields li.added input.position'), function(index) { 
			$(this).val(index);
		});
	}

	/* __ fields ___ */
	$('fieldset.fields li.added select').each(function() {
		var select = $(this)
			.hover(function() {
				clearTimeout(select.attr('timer')); 
			}, function() {
				select.attr('timer', setTimeout(function() { 
					select.hide();
					select.prev().show();
				}, 1000));
			})
			.change(function() { selectOnChange(select); });

		select.prev().click(function() {
			$(this).hide();
			select.show();
		});
	});

	$('fieldset.fields li.template input[type=text]').focus(function() {
		if ($(this).hasClass('void') && $(this).parents('li').hasClass('template'))
			$(this).val('').removeClass('void');
	});	

	$('fieldset.fields li.template button').click(function() {
		var lastRow = $(this).parents('li.template');
		
		var label = lastRow.find('input.label').val().trim();
		if (label == '' || label == defaultValue) return false;
		
		var newRow = lastRow.clone(true).removeClass('template').addClass('added new').insertBefore(lastRow);

		var dateFragment = '[' + new Date().getTime() + ']';
		newRow.find('input, select').each(function(index) {
			$(this).attr('name', $(this).attr('name').replace('[-1]', dateFragment));
		});

		var select = newRow.find('select')
			.val(lastRow.find('select').val())
			.change(function() { selectOnChange(select); })
			.hover(function() {
				clearTimeout(select.attr('timer')); 
			}, function() {
				select.attr('timer', setTimeout(function() { 
					select.hide();
					select.prev().show();
				}, 1000));
			});
		select.prev()
			.html(select[0].options[select[0].options.selectedIndex].text)
			.click(function() {
				$(this).hide();
				select.show();
			});

		// then "reset" the form
		lastRow.find('input.label').val(defaultValue).addClass('void');

		// warn the sortable widget about the new row
		$("fieldset.fields ol").sortable('refresh');
		
		refreshPosition();
	});

	$('fieldset.fields li a.remove').click(function(e) {
		if (confirm($(this).attr('data-confirm'))) {
			var parent = $(this).parents('li');
			
			if (parent.hasClass('new'))
				parent.remove();
			else {
				var field = parent.find('input.position')
				field.attr('name', field.attr('name').replace('[position]', '[_destroy]'));
				
				parent.hide().removeClass('added')
			}
			
			refreshPosition();
		}
			
		e.preventDefault();
		e.stopPropagation();
	});

	// sortable list
	$("fieldset.fields ol").sortable({ 
		handle: 'span.handle', 
		items: 'li:not(.template)', 
		axis: 'y',
		update: refreshPosition
	});
	
	// edit in depth custom field 
	$('fieldset.fields li.item span.actions a.edit').click(function() {
		var link = $(this);
		$.fancybox({ 
			titleShow: false,
			content: $(link.attr('href')).parent().html(),
			onComplete: function() {
				$('#fancybox-wrap form').submit(function(e) {
					$.fancybox.close();
					e.preventDefault();
					e.stopPropagation();
				});
				
				var parent = link.parent();
				
				if (parent.prevAll('select').val() == 'Text') {
					var formatting = parent.prevAll('.text-formatting').val();
					$('#fancybox-wrap #custom_fields_field_text_formatting').val(formatting);
					$('#fancybox-wrap #custom_fields_field_text_formatting_input').show();
				} else {
					$('#fancybox-wrap #custom_fields_field_text_formatting_input').hide();
				}
				
				var alias = parent.prevAll('.alias').val().trim();
				if (alias == '') alias = makeSlug(link.parent().prevAll('.label').val());
				$('#fancybox-wrap #custom_fields_field__alias').val(alias);
				
				var hint = parent.prevAll('.hint').val();
				$('#fancybox-wrap #custom_fields_field_hint').val(hint);
			},
			onCleanup: function() {
				var parent = link.parent();
				
				var alias = $('#fancybox-wrap #custom_fields_field__alias').val().trim();
				if (alias != '') parent.prevAll('.alias').val(alias);
				var hint = $('#fancybox-wrap #custom_fields_field_hint').val().trim();
				if (hint != '') parent.prevAll('.hint').val(hint);
				var formatting = $('#fancybox-wrap #custom_fields_field_text_formatting').val();
				parent.prevAll('.text-formatting').val(formatting);
			}
		})
	});
});