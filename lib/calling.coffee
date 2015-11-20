root = undefined
anim = undefined
DirectPano.show_pano = ()->
	image = $("<img id='start-image'/>")
	image.css({
		'visibility': 'visible',
		'height': Math.min(DirectPano.initial_height, window.innerHeight)  + 'px',
		'width': Math.min(DirectPano.initial_width, window.innerWidth) + 'px',
		'z-index': '1',
		'position': 'absolute',
		'left':'0px',
		'top': '0px' 
		})
	image.attr("src","./Dataset/panos-house/start.jpg")
	$("#" + DirectPano.pano_div_id).append(image)
	$("#panos-list").remove()
	$("#" + DirectPano.pano_div_id).append("<div id='panos-list'></div>")
	panos_list = $("#panos-list")
	i = 0
	while i < DirectPano.pano.length
		if DirectPano.pano[i][2] == true
			panos_list.append("<div id='panos-list-entry-" + i + "'>" + DirectPano.pano[i][0] + "</div>")
			$("#panos-list-entry-" + i).attr('pano_id', parseInt(i))
			$("#panos-list-entry-" + i).bind 'click touchstart', ->
				if root.Transition.moving == false
					root.Transition.start(null, parseInt(this.getAttribute('pano_id')))
				return
		i++

	root = require("./listeners.js")

	root.Annotation = new root.annotation(DirectPano.annotation_angles)
	root.Annotation.add_annotations(0)
	
	root.scene.children.length = 0

	root.add_listeners()

	root.Hotspot = new root.hotspot(DirectPano.hotspots_angle)
	root.Transition = new root.transition(DirectPano.pano, DirectPano.hotspots_angle)
	root.Hotspot.add_hotspots(0)

	anim = new root.animation()
	root.Config.isUserInteracting = true
	return

DirectPano.remove_pano = ->
	anim.destroy = true
	anim = null
	root.remove_listeners()
	root.Hotspot.destroy_hotspot()
	root.Hotspot = null
	root.Transition.destroy_transition()
	root.Transition = null
	root.Annotation.destroy_annotation()
	root.Annotation = null
	root.destroy()
	return