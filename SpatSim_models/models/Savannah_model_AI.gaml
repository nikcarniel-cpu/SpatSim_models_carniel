/**
* Name: Savannah_model_AI
* Description: Savannah model consisting of a bare 50 x 50 grid.
*/

model Savannah_model_AI

global {
	// The world has no attributes or reflexes yet; the grid is created by the cell species below.
}

// Grid species: one agent per cell of the 50 x 50 savannah grid (default Moore neighbourhood, 8 neighbours).
grid cell width: 50 height: 50 {
	// No attributes or reflexes yet (bare grid).
}

// Experiment showing the plain grid.
experiment Savannah type: gui {
	output {
		// Display of the grid cells without any colouring.
		display map type: 2d {
			grid cell border: #black;
		}
	}
}
