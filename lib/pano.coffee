root = require("./animation.js")
offset = [
		{
			position: [
				-150/2
				150/2
				0
			]
		}
		{
			position:[
				150/2
				150/2
				0
			]
		}
		{
			position: [
				-150/2
				-150/2
				0
			]
		}
		{
			position:[
				150/2
				-150/2
				0
			]
		}
]
dist = 150
sides = [
  {
    position: [
      -1*dist
      0
      0
    ]
    rotation: [
      0
      Math.PI/2
      0
    ]
  }
  {
    position: [
      dist
      0
      0
    ]
    rotation: [
      0
      -Math.PI/2
      0
    ]
  }
  {
    position: [
      0
      dist
      0
    ]
    rotation: [
      Math.PI / 2
      0
      Math.PI
    ]
  }
  {
    position: [
      0
      -1*dist
      0
    ]
    rotation: [
      -Math.PI / 2
      0
      Math.PI
    ]
  }
  {
    position: [
      0
      0
      dist
    ]
    rotation: [
      0
      Math.PI
      0
    ]
  }
  {
    position: [
      0
      0
      -1*dist
    ]
    rotation: [
      0
      0
      0
    ]
  }
]
class Pano
	constructor: (@pano_id,@is_blur) ->
		@name = "panorama"
		@destroy = false

	create_pano: (path1,opacity) ->
		@mesh = new THREE.Object3D()
		dfrd = []
		i = 0
		while i < 24
			dfrd[i] = $.Deferred()
			i++
		i = 0
		while i < 6
			j = 0
			slices = new THREE.Object3D()
			root.clear_images[@pano_id][i] = {}
			while j < 4
				path = path1
				console.log(path)
				path = path.replace(/%s/g,root.Config.img_name[i])
				path = path.replace(/%v/g,j%2)
				path = path.replace(/%h/g,parseInt(j/2))
				
				material = @load_texture(path , i,j,dfrd[4*i+j])
				geometry = if root.Config.webgl then new THREE.PlaneBufferGeometry( 300/2, 300/2, 7, 7 ) else  new THREE.PlaneGeometry( 300/2, 300/2, 20, 20)
				slice = new THREE.Mesh geometry , material
					
				slice.material.transparent = true
				slice.material.opacity = opacity
				slice.position.x = offset[j].position[0]
				slice.position.y = offset[j].position[1]
				slice.position.z = offset[j].position[2]
					
				slices.add(slice)
				j++
			slices.rotation.x = sides[i].rotation[0]
			slices.rotation.y = sides[i].rotation[1]
			slices.rotation.z = sides[i].rotation[2]

			slices.updateMatrix()

			slices.position.x = sides[i].position[0]
			slices.position.y = sides[i].position[1]
			slices.position.z = sides[i].position[2]

			slices.updateMatrix()

			@mesh.add(slices)
			i++
		root.scene.add @mesh

		return $.when.apply($, dfrd).done(->).promise()
		
	destroy_pano: () ->
		@destroy = true
		root.scene.remove(@mesh)
		i = 0
		while i < 6
			j = 0
			while j < 4
				@mesh.children[i].children[j].material.map.dispose()
				@mesh.children[i].children[j].material.dispose()
				@mesh.children[i].children[j].geometry.dispose()
				@mesh.children[i].children[j] = null
				j++
			@mesh.children[i] = null
			i++
	load_texture: (path,image_index,offset,dfrd) ->
		texture = new THREE.Texture root.texture_placeholder
		material = new THREE.MeshBasicMaterial( { map: texture, overdraw: 0 ,side:THREE.DoubleSide,blending: THREE.AdditiveBlending ,depthTest: false } )
		pano_id = @pano_id

		image = new Image();
		
		image.onload = ->
			image.onload = null
			texture.image = this
			texture.needsUpdate = true
			dfrd.resolve()
			root.clear_images[pano_id][image_index][offset] = image;
			
			return

		image.src = path

		return material

	get_texture: (panoid,path, dfrd, image_index,offset) ->
		flag = false
		texture = new THREE.Texture( root.texture_placeholder )
		panoid = @pano_id
		if root.clear_images[panoid][image_index][offset]
			flag = true
			texture.image = root.clear_images[panoid][image_index][offset]
			texture.needsUpdate = true
			dfrd.resolve()
			return texture

		if @is_blur is true and root.blur_images[panoid] and root.blur_images[panoid][image_index][offset]
			flag = true
			texture.image = root.blur_images[panoid][image_index][offset]
			texture.needsUpdate = true
			dfrd.resolve()
			return texture

		image = new Image()

		image.onload = ->
			texture.image = this
			texture.needsUpdate = true
			dfrd.resolve()
			return

		image.src = path

		return texture

root.Pano = Pano
module.exports = root



