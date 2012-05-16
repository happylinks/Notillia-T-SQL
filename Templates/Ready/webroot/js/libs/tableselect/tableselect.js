/*
 * Copyright (c) 2011 Noxa <jeffrey@noxa.nl>
 * Based on Arron Bailiss <arron@arronbailiss.com> jQuery Shift-click Plugin
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

(function($) {
	$.fn.multiSelect = function() {
		var clickedClass = 'selected';
		var lastSelected;
		var tableRows = $(this);
		
		this.each(function() {
			$(this).children('td').attr('unselectable', 'on');
			$(this).click(function(e) {
				if(e.ctrlKey || e.metaKey) {
					$(this).toggleClass('selected');
				}else if(e.shiftKey){
					var last = tableRows.index(lastSelected);
					var first = tableRows.index(this);
					var start = Math.min(first, last);
					var end = Math.max(first, last);

					for (var i = start; i < end +1; i++) {
						if (tableRows[i].children[0].tagName.toLowerCase() == 'td') {
							$(tableRows[i]).addClass('selected');
						}
					}
				}else{
					var table = $(this).parent();
					var clickedIsSelected = $(this).hasClass("selected")
					var lastIndex = 0;
					
					$("tr", table).each(function(i, obj) {
						if($(obj).hasClass("selected")) {
							lastIndex++;
						}
						
						$(obj).removeClass('selected');
					});
					
					if(!clickedIsSelected || lastIndex > 1) {
						$(this).addClass('selected');
					}
					lastSelected = this;
				}
			});
		});
	};
})(jQuery);