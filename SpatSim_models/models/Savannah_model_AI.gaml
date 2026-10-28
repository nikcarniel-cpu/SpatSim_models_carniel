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
	// World shape of 100 x 100 units, so that 1 cell equals 1 unit.
	geometry shape <- square(100);

	// Creates the lions and zebras at random locations on the grid.
	init {
		create lion number: nb_lions;
		create zebra number: nb_zebras;
	}
}

// Grid species: one agent per cell of the 100 x 100 savannah grid (default Moore neighbourhood, 8 neighbours).
grid cell width: 100 height: 100 {
	// No attributes or reflexes yet (bare grid).
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
			grid cell border: #black;
			species lion aspect: default;
			species zebra aspect: default;
		}
	}
}
