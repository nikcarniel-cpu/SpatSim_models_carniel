# Prompt Log

| # | Prompt summary | Change summary | Comment | Model version |
|---|----------------|----------------|---------|---------------|
| 1 | Build savannah_demographic_ai from the extended model: lion age list, ageing every 52 cycles, death at 60, per-cycle report, red shading by age. | New `SpatSim_models/models/savannah_demographic_ai.gaml` (copy of `Savannah_model_AI_extended.gaml`): global `cycles_per_year`, `max_age`, `lion_ages`, reflex `report_ages`; lion `age`, `previous_age`, reflexes `get_older`, `die_of_old_age`, `starve` updated, aspect shaded red; new `prompt_log.md`. | Untested in GAMA. Colour scales each lion's own age from 1 to 60; the mean age is only reported, not used for colour. Unsure: `rnd(1, 59)`, `min`/`mean`/`max` on lists, `rgb(...)`. | savannah_demographic_ai draft (after v0.2) |
| 2 | Commit the first version of savannah_demographic_ai and the prompt log to a new branch `developer`. | Created branch `developer`; committed `savannah_demographic_ai.gaml` and `prompt_log.md`. Not pushed. | User checked the model; further work is still needed. | savannah_demographic_ai v0.1 draft (branch `developer`) |
