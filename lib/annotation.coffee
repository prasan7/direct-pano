root = require("./hotspot.js")
object = undefined
class annotation
	constructor:(@annotation_angles,@content) ->
		@panoid = undefined
		@length = 0
		@destroy = false

	add_annotation:(annotation_id)->
		anno_id = annotation_id
		annotation_id = "annotation_" + annotation_id
		div = $("<div></div>",{id : annotation_id})
		div.prepend("<img class='annotation' height='40px' width='40px' src='../test/images/info.png'></img>
			<div class='hotspot-title'>
				<div class='hotspot-text'>" + @annotation_angles[@panoid][anno_id][2] +
				"</div>
			</div>
			<div class='info-hotspot'>
				" + @annotation_angles[@panoid][anno_id][3] +
			"</div>
			")
		$("#" + DirectPano.pano_div_id).append(div)

		$("#" + annotation_id).bind 'click touchstart', ->
			if $("#" + annotation_id).find('.info-hotspot').css('visibility') == 'visible'
				$("#" + annotation_id).find('.info-hotspot').css('visibility', 'hidden')
				$("#" + annotation_id).find('.hotspot-title').css('visibility', 'hidden')
				$("#" + annotation_id).find('.hotspot-title').css('opacity', '0')
				$("#" + annotation_id).find('.annotation').css('border-radius', '100px')
				return
			else
				$("#" + annotation_id).find('.info-hotspot').css('visibility', 'visible')
				$("#" + annotation_id).find('.hotspot-title').css('visibility', 'visible')
				$("#" + annotation_id).find('.hotspot-title').css('opacity', '1')
				$("#" + annotation_id).find('.hotspot-title').css('border-radius', '0px 10px 0px 0px')
				$("#" + annotation_id).find('.annotation').css('border-radius', '10px 0px 0px 0px')
				return
		$("#" + annotation_id).hover (->
			$("#" + annotation_id).find('.hotspot-title').css('visibility', 'visible')
			$("#" + annotation_id).find('.hotspot-title').css('opacity', '1')
			if $("#" + annotation_id).find('.info-hotspot').css('visibility') == 'hidden'
				$("#" + annotation_id).find('.hotspot-title').css('border-radius', '0px 10px 10px 0px')
				$("#" + annotation_id).find('.annotation').css('border-radius', '10px 0px 0px 10px')
			return
		), ->
			if $("#" + annotation_id).find('.info-hotspot').css('visibility') == 'hidden'
				$("#" + annotation_id).find('.hotspot-title').css('visibility', 'hidden')
				$("#" + annotation_id).find('.hotspot-title').css('opacity', '0')
				$("#" + annotation_id).find('.annotation').css('border-radius', '100px')
			return
		return
	
	add_annotations:(panoid)->
		@panoid = panoid
		try
			@length = @annotation_angles[panoid].length
			i = 0
			while i < @length
				if @destroy
					@remove_annotations()
					return
				@add_annotation(i)
				i++
		catch
			@length = 0
			return
		return

	remove_annotations:->
		i = 0
		while i < @length
			$("#annotation_" + i).remove()
			i++
		return

	destroy_annotation:->
		@destroy = true
		@remove_annotations()
	
	update:()->
		i = 0
		panoid = @panoid
		while i < @length
			annotation_id = "#annotation_" + i
			annotation = $(annotation_id)
			angle = @annotation_angles[panoid][i][0]
			rad_angle =THREE.Math.degToRad(angle)
			vector = new (THREE.Vector3)(30*Math.cos(rad_angle), @annotation_angles[@panoid][i][1], 30*Math.sin(rad_angle))
			vector.x += 13*Math.cos(rad_angle)
			vector.z += 13*Math.sin(rad_angle)
			vector = vector.project(root.camera)
			container = $("#" + DirectPano.pano_div_id)
			pos =
				x: (vector.x + 1)/2 * container.outerWidth()
				y: -(vector.y - 1)/2 * container.outerHeight()
			if annotation
				if(vector.x > 1 or vector.x < -1 or vector.y > 1 or vector.y < -1 or vector.z > 1 or vector.z < -1)
					if( $(annotation_id).css('display') != 'none')
						$(annotation_id).removeAttr('style')
						$(annotation_id).css('display', 'none')
				else 
					$(annotation_id).css('display', 'inline')
					$(annotation_id).css('left', '-10px')
					$(annotation_id).css('top', '0px')
					$(annotation_id).css('transform', 'translate3d(' + (pos.x) + 'px,' + (pos.y) + 'px,0px)')
					$(annotation_id).css('position', 'absolute')
					$(annotation_id).css('font-family': "'Helvetica Neue', Helvetica, Arial, sans-serif")
					$(annotation_id).css('font-size', '16px')
			i++
		return
root.annotation = annotation
module.exports = root
