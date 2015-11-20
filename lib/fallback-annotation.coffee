root = require('./fallback-hotspot.js')
class Annotation
	constructor:(pano_id)->
		@pano_id = pano_id
		@length = undefined

	add_annotation:(annotation_id,top,left)->
		div1 = $("#screen1")
		div2 = $("#screen2")
		pano_id = @pano_id
		anno_id = annotation_id
		
		annotation_id = "annotation_1_" + anno_id
		anno_div1 = $("<div></div>",{id : annotation_id})
		anno_div1.prepend("<img class='annotation' height='40px' width='40px' src='../test/images/info.png'></img>
			<div class='hotspot-title'>
				<div class='hotspot-text'>" + root.annotation_angles[pano_id][anno_id][2] +
				"</div>
			</div>
			<div class='info-hotspot'>
				" + root.annotation_angles[pano_id][anno_id][3] +
			"</div>
			")	
		anno_div1.on('click' , ->
			if anno_div1.find('.info-hotspot').css('visibility') == 'visible'
				anno_div1.find('.info-hotspot').css('visibility', 'hidden')
			else
				anno_div1.find('.info-hotspot').css('visibility', 'visible')
			return)
		
		anno_div1.css('display', 'inline')
		anno_div1.css('position', 'absolute')
		anno_div1.css('left', left)
		anno_div1.css('top', top)
		anno_div1.css('font-family': "'Helvetica Neue', Helvetica, Arial, sans-serif")
		anno_div1.css('font-size', '16px')

		div1.append(anno_div1)

		
		annotation_id = "annotation_2_" + anno_id
		anno_div2 = $("<div></div>",{id : annotation_id})
		anno_div2.prepend("<img class='annotation' height='40px' width='40px' src='../test/images/info.png'></img>
			<div class='hotspot-title'>
				<div class='hotspot-text'>" + root.annotation_angles[pano_id][anno_id][2] +
				"</div>
			</div>
			<div class='info-hotspot'>
				" + root.annotation_angles[pano_id][anno_id][3] +
			"</div>
			")
		anno_div2.on('click', ->
			if anno_div2.find('.info-hotspot').css('visibility') == 'visible'
				anno_div2.find('.info-hotspot').css('visibility', 'hidden')
			else
				anno_div2.find('.info-hotspot').css('visibility', 'visible')
			return)

		anno_div2.css('display', 'inline')
		anno_div2.css('position', 'absolute')
		anno_div2.css('left', left)
		anno_div2.css('top', top)
		anno_div2.css('font-family': "'Helvetica Neue', Helvetica, Arial, sans-serif")
		anno_div2.css('font-size', '16px')
		
		div2.append(anno_div2)
		return
	
	add_annotations:()->
		pano_id = @pano_id
		@length = root.annotation_angles[pano_id].length
		i = 0
		while i < @length
			top = (root.height/2 - 2*root.annotation_angles[pano_id][i][1]) + 'px'
			console.log(root.annotation_angles[pano_id][i][1] , top)
			angle = (root.annotation_angles[pano_id][i][0] + 80)%360
			left = ((angle/360)*1500) + 'px'
			@add_annotation(i,top,left)
			i++
		return
	
	remove_annotations:()->
		i = 0
		while i < @length
			$("#annotation_1_" + i).off()
			$("#annotation_2_" + i).off()
			$("#annotation_1_" + i).remove()
			$("#annotation_2_" + i).remove()
			i++
		return


root.Annotation = Annotation
module.exports = root
