/**
* Name: farm_model
* Description: Farm model on a 100 x 100 torus world. Cows do a correlated random walk,
* sheep walk south and goats walk to the origin {0,0}. Each agent shows its action
* neighbourhood (area reachable in its next step) as a 30% transparent overlay.
* See SPECIFICATION.md.
*/

model farm_model

global {
	// Number of cows created at the start (slider).
	int nb_cows <- 5;
	// Number of sheep created at the start (slider).
	int nb_sheep <- 3;
	// Number of goats created at the start (slider).
	int nb_goats <- 2;
	// Opacity of the action neighbourhood overlay (0.3 = 30%, first guess).
	float overlay_alpha <- 0.3;
	// Display factor for the cow's action neighbourhood: sector radius = speed * this factor (slider; 1 = true size).
	float neighbourhood_scale <- 3.0;
	// Length of the sheep's neighbourhood line pointing south (slider).
	float sheep_line_length <- 3.0;
	// Length of the goat's neighbourhood line pointing towards {0,0} (slider).
	float goat_line_length <- 3.0;
	// Fixed thickness of the neighbourhood lines of sheep and goats (no slider any more).
	float line_thickness <- 0.4;
	// Fixed random seed so that runs are reproducible (value 42 is an assumption).
	float seed <- 42.0;
	// World shape of 100 x 100 units.
	geometry shape <- square(100);
	// Wrap-around world: agents leaving one edge re-enter on the opposite edge.
	bool torus_environment <- true;

	// Creates the cows, sheep and goats at random locations.
	init {
		create cow number: nb_cows;
		create sheep number: nb_sheep;
		create goat number: nb_goats;
	}
}

// Cow: correlated random walk, brown circle with a circle sector as action neighbourhood.
species cow skills: [moving] {
	// Distance moved per step.
	float speed <- 2.0;
	// Colour of the cow and its neighbourhood.
	rgb color <- #brown;

	// Correlated random walk: heading changes by at most +-45 degrees (amplitude 90).
	reflex walk {
		do wander amplitude: 90.0;
	}

	// Circle sector of radius = speed * neighbourhood_scale, centred on the heading, opening angle 90 degrees,
	// starting at the cow's position; drawn from the current heading every step.
	geometry neighbourhood {
		float radius <- speed * neighbourhood_scale;
		list<point> arc_points <- [-45, -30, -15, 0, 15, 30, 45] collect (location + {radius * cos(heading + each), radius * sin(heading + each)});
		return polygon([location] + arc_points);
	}

	// Draws the transparent neighbourhood first, then the cow as a circle of size 2.
	aspect default {
		draw neighbourhood() color: rgb(color, overlay_alpha);
		draw circle(2) color: color;
	}
}

// Sheep: always walk south (heading 90), black circle with a line as action neighbourhood.
species sheep skills: [moving] {
	// Distance moved per step.
	float speed <- 1.0;
	// Colour of the sheep and its neighbourhood.
	rgb color <- #black;

	// Moves south (heading 90 degrees; the y-axis points downwards).
	reflex walk {
		do move heading: 90.0;
	}

	// Draws the transparent line (as a thin buffered shape) of length sheep_line_length
	// pointing south, then the sheep as a circle of size 2.
	aspect default {
		draw line([location, location + {0, sheep_line_length}]) + line_thickness color: rgb(color, overlay_alpha);
		draw circle(2) color: color;
	}
}

// Goat: walks slowly to the origin {0,0} and stays there; yellow circle with a line as action neighbourhood.
species goat skills: [moving] {
	// Distance moved per step.
	float speed <- 0.5;
	// Colour of the goat and its neighbourhood.
	rgb color <- #yellow;
	// Target the goat walks to.
	point target <- {0, 0};

	// Walks towards the target; goto stops the goat once it has arrived.
	reflex walk {
		do goto target: target;
	}

	// Draws the transparent line (thin buffered shape) of length goat_line_length, always pointing
	// towards {0,0}, then the goat as a circle of size 2.
	aspect default {
		float dir <- location towards target;
		draw line([location, location + {goat_line_length * cos(dir), goat_line_length * sin(dir)}]) + line_thickness color: rgb(color, overlay_alpha);
		draw circle(2) color: color;
	}
}

// Experiment with one display on a light green background and sliders for the agent counts.
experiment Farm type: gui {
	// Slider for the number of cows.
	parameter "Number of cows" var: nb_cows min: 0 max: 50 step: 1 category: "Agents";
	// Slider for the number of sheep.
	parameter "Number of sheep" var: nb_sheep min: 0 max: 50 step: 1 category: "Agents";
	// Slider for the number of goats.
	parameter "Number of goats" var: nb_goats min: 0 max: 50 step: 1 category: "Agents";

	// Slider for the display size of the cow's action neighbourhood (1 = true size).
	parameter "Cow neighbourhood scale" var: neighbourhood_scale min: 1.0 max: 10.0 step: 0.5 category: "Display";
	// Slider for the length of the sheep line.
	parameter "Sheep line length" var: sheep_line_length min: 0.5 max: 20.0 step: 0.5 category: "Display";
	// Slider for the length of the goat line.
	parameter "Goat line length" var: goat_line_length min: 0.5 max: 20.0 step: 0.5 category: "Display";
	// Slider for the opacity of the neighbourhood overlays.
	parameter "Overlay opacity" var: overlay_alpha min: 0.1 max: 1.0 step: 0.1 category: "Display";

	output {
		// Single display showing all agents and their action neighbourhoods.
		display "Farm" background: #lightgreen {
			species cow;
			species sheep;
			species goat;
		}
	}
}
