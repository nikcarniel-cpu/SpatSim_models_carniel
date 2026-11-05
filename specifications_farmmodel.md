# Specification: Farm model

## Environment
The Farm model is a new GAMA model with a world of 100 × 100 units.
In GAMA, east has heading 0° and headings increase clockwise, so south is heading 90°. The y-axis points downwards.

## Cows
- 5 cows are created at random locations.
- Cows are drawn as brown circles of size 2.
- Cows move with a correlated random walk at a speed of 2.
- The heading changes by at most ±45° per step (wander amplitude 90°).

## Sheep
- 3 sheep are created at random locations.
- Sheep are drawn as black circles of size 2.
- All sheep move towards the south (heading 90°) at a speed of 1.

## Goats
- 2 goats are created at random locations.
- Goats are drawn as yellow circles of size 2.
- Goats walk slowly towards the origin {0,0} at a speed of 0.5.

## Action neighbourhood
- For every agent, the area it can reach in its next step is visualised as a transparent shape in the agent's colour.
- Cows: a circle sector with radius 2 (speed), centred on the current heading, with an opening angle of 90° (±45°).
- Sheep: a line of length 1 (speed) pointing south.
- Goats: a line of length 0.5 (speed) pointing towards {0,0}.

## Display
- One display shows all agents and their action neighbourhoods on a plain background.
