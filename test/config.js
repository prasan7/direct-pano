var full_dataset = {};
// full_dataset ={
//	"panos-house": DirectPano,
//	"panos": DirectPano,
//}

var test_pano = [];
var fallback_pano = [];
var titles = ["Entrance", "Kitchen", "Hall", "Hall", "Hall", "", "Bedroom 1", "Bedroom 1", "Bedroom 1", "Bedroom 1", "Bathroom 1", "", "", "Bedroom 3", "Bedroom 3", "Bathroom 3", "Bedroom 3", "Bedroom 3", "Bedroom 2", "Bathroom 2", "Bedroom 2", "Bedroom 2"];
var side_panel = [true, true, false, true, false, false, true, false, false, false, true, false, false, true, false, true, false, false, true, true, false, false];
for(var i=0;i<22;i++)
{
    test_pano[i] = [titles[i], "./Dataset/panos-house/" + (i + 1) + "/%s/%h_%v.jpg", side_panel[i],0];
    fallback_pano[i] = "./Dataset/panos-house/" + (i + 1) + '/';
}
var DirectPano = 
{
	hotspots_angle : [[[1, 70, -26, "Kitchen"], [2, 340, -21, "Hall Entrance"]], [[0, 225, 0, "Main Door"]], [[0, 140, 0, "Main Door"], [3, 0, 0, "Hall Center"]], [[2, 190, 0, "Hall Entrance"], [4, 330, 0, "Hall Window"], [5, 53, 0]], [[3, 135, 0, "Hall Center"], [9, 332, 0]], [[3, 222, 0, "Hall Center"], [6, 315, 0, "Bedroom 1"], [11, 47, 0]], [[5, 120, 0], [7, 210, 0], [8, 295, 0]], [[6, 25, 0, "Bedroom 1"]], [[6, 123, 0, "Bedroom 1"], [9, 220, 0]], [[8, 70, 0], [4, 177, 0, "Hall Window"]], [[11, 340, 0]], [[12, 320, 0], [5, 230, 0], [10, 170, 0, "Bathroom 1"]], [[11, 135, 0], [13, 45, 0, "Bedroom 3"], [18, 313, 0, "Bedroom 2"]], [[12, 245, 0], [14, 130, 0], [16, 63, 0]], [[13, 305, 0, "Bedroom 3"], [15, 145, 0, "Bathroom 3"]], [[14, 305, 0]], [[13, 220, 0, "Bedroom 3"], [17, 75, 0]], [[16, 255, 0]], [[12, 130, 0], [19, 328, 0, "Bathroom 2"], [20, 10, 0]], [[18, 135, 0, "Bedroom 2"]], [[18, 182, 0, "Bedroom 2"], [21, 40, 0]], [[20, 215, 0]]],
	pano_div_id : "container",
	image_div_id : "fullscreen-image",
	initial_width : 490,
	initial_height : 336,
	annotation_angles : [ [],
						  [[250, 0,"Fridge", "Samsung <br>400 L "], [56, -20,"Washing Machine", "LG <br>5.5 Kg"]],
						  [],
						  [ [0, 18, "AC", "Samsung <br>1 Ton"], [75, 14, "AC", "Samsung <br>1 Ton"], [0, 0, "TV", "Phillips (LCD) <br> 32 inch"] ],
						  [ [82, 0, "TV", "Phillips (LCD) <br> 32 inch"] ],
						  [],
						  [ [260, -16, "Bed", "Queen Size <br>6' x 5'"], [278, 14, "AC", "Samsung <br>1 Ton"], [197, 0, "Almirah", "6' x 3' x 1'"] ],
						  [ [335, 0, "Almirah", "6' x 3' x 1'"] ],
						  [],
						  [],
						  [],
						  [],
						  [],
						  [ [95, -16, "Bed", "Queen Size <br>6' x 5'"], [82, 14, "AC", "Samsung <br>1 Ton"] ],
						  [],
						  [],
						  [ [183, 0, "Almirah", "6' x 3' x 1'"] ],
						  [],
						  [ [26, 14 ,  "AC", "Samsung <br>1 Ton"] ],
						  [],
						  [ [133, -20, "Bed", "Single <br>6' x 4'"], [200, 0, "Almirah",  "6' x 2' x 1'"] ]
						],
	pano: test_pano,
	fallback_pano : fallback_pano

};
$.getJSON( "data.json", function( data ) {
	dpano = {};
	hotspots_angle = [];
	annotation_angles = [];

	mapping = {};
	pano = [];
	var num_panos = Object.keys(data).length;
	for (var i = 0; i < num_panos; i++)
	{
		hotspots_angle[i] = [];
		annotation_angles[i] = [];
		pano[i] = [];
		mapping[i.toString()] = i;	// This mapping needs to be changed to id -> 0...num_panos where id is 16 bit string generated by server
	}
	Scene = data;
	$.each( Scene, function( k, v ) {
		title = Scene[k]["title"];
		path = Scene[k]["path"];
		side_panel = Scene[k]["side_panel"]
		start_position = Scene[k]["start_position"]
		pano[mapping[k]] = [title, path, side_panel, start_position];
		for(var i = 0; i < Scene[k]["hotspot"].length; i++)
		{
			new_dict = Scene[k]["hotspot"][i];
			if(new_dict["text"]!=undefined)
				new_array = [mapping[new_dict["to_id"]], new_dict["angle"], new_dict["error"], new_dict["text"]];
			else
				new_array = [mapping[new_dict["to_id"]], new_dict["angle"], new_dict["error"]];
			hotspots_angle[mapping[k]].push(new_array);
		}
		for(var i = 0; i < Scene[k]["annotation"].length; i++)
		{
			annotation = Scene[k]["annotation"][i];
			single_annotation = [annotation["lon"], annotation["lat"], annotation["title"], annotation["desc"]];
			annotation_angles[mapping[k]].push(single_annotation);
		}
	});
	dpano["hotspots_angle"] = hotspots_angle;
	dpano["annotation_angles"] = annotation_angles;
	dpano["pano"] = pano;
	full_dataset = dpano;
});