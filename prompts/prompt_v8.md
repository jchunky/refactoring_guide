### Code Smell Priorities (in order of importance)

1. __Feature Envy__ - When a method uses another object's data excessively, move the behavior to that object. Ask objects to do things, don't reach into them.
2. __Long Parameter Lists__ - Group related parameters into parameter objects
3. __Primitive Obsession__ - Consider small objects when primitives gain behavior
4. __Data Clumps__ - Group data that travels together into structures
