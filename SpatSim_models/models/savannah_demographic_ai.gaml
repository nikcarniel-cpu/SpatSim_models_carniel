/**
* Name: savannah_demographic_ai
* Description: Extension of Savannah_model_AI_extended on a 100 x 100 grid: zebras eat grass,
* lions lose energy when moving, gain energy from eating zebras and die at 0 energy.
* The lion population is recorded in an age list (1 cycle = 1 week, 52 cycles = 1 year);
* lions die of old age at 60 years and are shaded red according to their age.
*/

model savannah_demographic_ai

global {
	// Number of lions created at the start of the simulation.
	int nb_lions <- 20;
	// Number of zebras created at the start of the simulation.
	int nb_zebras <- 20;
	// Distance in cells within which a lion kills a zebra.
	float kill_distance <- 3.0;
	// Grass biomass in kg added to every cell per cycle (linear growth).
	float grass_growth <- 0.1;
	// Grass biomass in kg a zebra eats per cycle.
	float eating_rate <- 5.0;
	// Energy a lion has at the start of the simulation.
	float lion_start_energy <- 200.0;
	// Energy a lion loses per cycle when moving.
	float move_energy_cost <- 1.0;
	// Energy a lion gains for every zebra it kills (assumed value, not yet confirmed).
	float kill_energy_gain <- 20.0;
	// Amplitude in degrees of the heading change when lions and zebras walk.
	float walk_amplitude <- 60.0;
	// Number of cycles that make up one year (1 cycle = 1 week).
	int cycles_per_year <- 52;
	// Age in years at which a lion dies and disappears.
	int max_age <- 60;
	// Ages of all living lions, one value per lion.
	list<int> lion_ages <- [];
	// World shape of 100 x 100 units, so that 1 cell equals 1 unit.
	geometry shape <- square(100);

	// Creates the lions and zebras at random locations on the grid and records the ages of all lions.
	init {
		create lion number: nb_lions;
		create zebra number: nb_zebras;
		ask lion {
			add age to: lion_ages;
		}
	}

	// Reports the number of values in the age list and their minimum, mean and maximum every cycle.
	reflex report_ages {
		if empty(lion_ages) {
			write "Cycle " + cycle + ": no lions left";
		} else {
			write "Cycle " + cycle + ": n = " + length(lion_ages) + ", min = " + min(lion_ages) + ", mean = " + with_precision(mean(lion_ages), 2) + ", max = " + max(lion_ages);
		}
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

// Lion species: wanders over the grid, kills zebras that come within range and dies when out of energy.
species lion skills: [moving] {
	// Movement speed in cells per cycle.
	float speed <- 1.0;
	// Energy of the lion; it dies when this reaches 0.
	float energy <- lion_start_energy;
	// Age of the lion in years, random between 1 and 59 at the start.
	int age <- rnd(1, 59);
	// Age of the lion before its last birthday, used to replace it in the age list.
	int previous_age <- age;

	// Moves the lion randomly over the grid and costs energy.
	reflex move {
		do wander amplitude: walk_amplitude;
		energy <- energy - move_energy_cost;
	}

	// Kills every zebra within kill_distance cells of the lion and gains energy for each one.
	reflex kill {
		list<zebra> prey <- zebra at_distance kill_distance;
		energy <- energy + kill_energy_gain * length(prey);
		ask prey {
			do die;
		}
	}

	// Lets the lion die when its energy has run out, removing its age from the list.
	reflex starve when: energy <= 0 {
		lion_ages >- age;
		do die;
	}

	// Ages the lion by one year every 52 cycles and replaces its previous age by the current age in the list.
	reflex get_older when: (cycle > 0) and (cycle mod cycles_per_year = 0) {
		previous_age <- age;
		age <- age + 1;
		lion_ages >- previous_age;
		add age to: lion_ages;
	}

	// Lets the lion die of old age at max_age, removing its age from the list.
	reflex die_of_old_age when: age >= max_age {
		lion_ages >- age;
		do die;
	}

	// Draws the lion as a red circle of size 3, light red when young and dark red when old.
	aspect default {
		float fill <- (age - 1) / (max_age - 1);
		draw circle(3) color: rgb(int(255 - 135 * fill), int(200 * (1 - fill)), int(200 * (1 - fill)));
	}
}

// Zebra species: wanders over the grid and eats grass.
species zebra skills: [moving] {
	// Movement speed in cells per cycle.
	float speed <- 1.0;

	// Moves the zebra randomly over the grid.
	reflex move {
		do wander amplitude: walk_amplitude;
	}

	// Eats grass from the cell the zebra stands on, never more than is left there.
	reflex eat {
		cell current_cell <- cell closest_to self;
		float eaten <- min(eating_rate, current_cell.biomass);
		current_cell.biomass <- current_cell.biomass - eaten;
	}

	// Draws the zebra as a gray triangle of size 2.
	aspect default {
		draw triangle(2) color: #gray;
	}
}

// Experiment showing the grass, lions and zebras.
experiment Savannah type: gui {
	output {
		// Display of the grass cells with the lions and zebras on top.
		display map type: 2d {
			grid cell;
			species lion aspect: default;
			species zebra aspect: default;
		}
	}
}
