function find_slides(text)
   if string.find(text, "-") then
      if text:sub(1,1) == '-' then
	 first_slide = 1
	 last_slide = tonumber(text:sub(2))
      else
	 slide_slice = string.gmatch(text, "[^-]+")
	 f1 = slide_slice()
	 f2 = slide_slice(f1)
	 first_slide = tonumber(f1)
	 last_slide = tonumber(f2)
      end
   else
      first_slide = tonumber(text)
      last_slide = tonumber(text)	    
   end
   return first_slide, last_slide
end


function onslide_div(div, slide_in, slide_out)
   local slides = div.attributes['slides']
   div.attributes['slides'] = nil      
   first_slide, last_slide = find_slides(slides)
   
   if first_slide == 1 then
      div.classes:insert("fragment")	 
      div.classes:insert("custom")	 
      div.classes:insert(slide_out)
      div.attributes['fragment-index'] = last_slide
   else
      if last_slide == nil then
	 div.classes:insert("fragment")	 
	 div.classes:insert("custom")	 
	 div.classes:insert(slide_in)
	 div.attributes['fragment-index'] = first_slide - 1	    	    
      else
	 div.classes:insert("fragment")	 
	 div.classes:insert("custom")	 
	 div.classes:insert(slide_out)
	 div.attributes['fragment-index'] = last_slide	    
	 attributes = { class='fragment custom ' .. slide_in, ['fragment-index'] = first_slide - 1 }
	 div = pandoc.Div(div, attributes)
      end
   end
   return div
end

function onslide_span(span, slide_in, slide_out)
   local slides = span.attributes['slides']
   span.attributes['slides'] = nil      
   first_slide, last_slide = find_slides(slides)
   
   if first_slide == 1 then
      span.classes:insert("fragment")	 
      span.classes:insert("custom")	 
      span.classes:insert(slide_out)
      span.attributes['fragment-index'] = last_slide
   else
      if last_slide == nil then
	 span.classes:insert("fragment")	 
	 span.classes:insert("custom")	 
	 span.classes:insert(slide_in)
	 span.attributes['fragment-index'] = first_slide - 1	    	    
      else
	 span.classes:insert("fragment")	 
	 span.classes:insert("custom")	 
	 span.classes:insert(slide_out)
	 span.attributes['fragment-index'] = last_slide	    
	 attributes = { class='fragment custom ' .. slide_in, ['fragment-index'] = first_slide - 1 }
	 span = pandoc.Span(span, attributes)
      end
   end
   return span
end


function Div(div)
   if not quarto.doc.is_format("revealjs") then
      return div
   end
   if div.classes:find("onslide") then
      a,b = div.classes:find("onslide")
      div.classes:remove(b)
      div.classes["onslide"] = nil
      return onslide_div(div, "onslide-in", "onslide-out")
   elseif div.classes:find("onlyslide") then
      a,b = div.classes:find("onlyslide")
      div.classes:remove(b)
      div.classes["onlyslide"] = nil
      return onslide_div(div, "onlyslide-in", "onlyslide-out")
   else      
      return div
   end
end

function Span(span)
   if not quarto.doc.is_format("revealjs") then
      return span
   end
   if span.classes:find("onslide") then
      a,b = span.classes:find("onslide")
      span.classes:remove(b)
      span.classes["onslide"] = nil
      return onslide_span(span, "onslide-in", "onslide-out")
   elseif span.classes:find("onlyslide") then
      a,b = span.classes:find("onlyslide")
      span.classes:remove(b)
      span.classes["onlyslide"] = nil
      return onslide_span(span, "onlyslide-in", "onlyslide-out")
   else      
      return span
   end
end


function Meta(meta)
   if not quarto.doc.is_format("revealjs") then
      return meta
   end
   quarto.doc.add_html_dependency({
	 name = 'onslide',
	 stylesheets={'onslide.css'}})
end
