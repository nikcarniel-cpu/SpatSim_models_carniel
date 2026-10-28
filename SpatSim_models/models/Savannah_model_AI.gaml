/**
* Name: Savannah_model_AI
* Description: Savannah model with a 100 x 100 grid, lions and zebras.
*/

model Savannah_model_AI

global {
	// Number of lions created at the start of the simulation.
	int nb_lions <- 20;
	// Number of zebras created at the start of the simulation.
	int nb_zebras <- 20;
	// Distance in cells within which a lion kills a zebra.
	float kill_distance <- 3.0;
	// Grass biomass in kg added to every cell per cycle (linear growth).
	float grass_growth <- 0.1;
	// World shape of 100 x 100 units, so that 1 cell equals 1 unit.
	geometry shape <- square(100);

	// Creates the lions and zebras at random locations on the grid.
	init {
		create lion number: nb_lions;
		create zebra number: nb_zebras;
	}
}

// Grid species: one agent per cell of the 100 x 100 savannah grid (default Moore neighbourhood, 8 neighbours).
// Each cell is a cellular automaton cell holding grass.
grid cell width: 100 height: 100 {
	// Maximum grass biomass of the cell in kg.
	float max_biomass <- 10.0;
	// Grass biomass of the cell in kg, random between 0 and 10 at the start.
	float biomass <- rnd(max_biomass);
	// Colour of the cell, from white (no grass) to green (maximum grass); updated at the end of every cycle.
	rgb color <- grass_colour() update: grass_colour();

	// Adds linear grass growth each cycle, capped at max_biomass.
	reflex grow {
		biomass <- min(max_biomass, biomass + grass_growth);
	}

	// Returns the colour for the current biomass, interpolated from white to green.
	action grass_colour type: rgb {
		float fill <- biomass / max_biomass;
		return rgb(int(255 * (1 - fill)), int(255 - 127 * fill), int(255 * (1 - fill)));
	}
}

// Lion species: wanders over the grid and kills zebras that come within range.
species lion skills: [moving] {
	// Movement speed in cells per cycle.
	float speed <- 1.0;

	// Moves the lion randomly over the grid.
	reflex move {
		do wander;
	}

	// Kills every zebra within kill_distance cells of the lion.
	reflex kill {
		ask (zebra at_distance kill_distance) {
			do die;
		}
	}

	// Draws the lion as an orange circle of size 3.
	aspect default {
		draw circle(3) color: #orange;
	}
}

// Zebra species: wanders over the grid.
species zebra skills: [moving] {
	// Movement speed in cells per cycle.
	float speed <- 1.0;

	// Moves the zebra randomly over the grid.
	reflex move {
		do wander;
	}

	// Draws the zebra as a gray triangle of size 2.
	aspect default {
		draw triangle(2) color: #gray;
	}
}

// Experiment showing the grid, lions and zebras.
experiment Savannah type: gui {
	output {
		// Display of the grid cells with the lions and zebras on top.
		display map type: 2d {
			grid cell;
			species lion aspect: default;
			species zebra aspect: default;
		}
	}
}
