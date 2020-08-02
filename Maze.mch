/* Maze
 * Author: Lakshan.S w1654456 2016360
 * Creation date: 12/14/19
 */
MACHINE
    Maze
    
CONSTANTS
    entry_point, // Entry point in the maze
    exit_point, // Exit point in the maze
    maze, // The maze which includes all the squares
    walls, // Blocked internal walls in the maze
    x_max, // Number of squares in the x axis of the maze
    y_max // Number of squares in the y axis of the mazes
    
PROPERTIES
    x_max : NATURAL1 &
    
    y_max : NATURAL1 &
    
    maze : NATURAL1 <-> NATURAL1 &
    
    entry_point : maze &
    
    exit_point : maze &
    
    walls <: maze &
    
    x_max = 7 & 
    
    y_max = 5 &
    
    maze = (1..x_max) * (1..y_max) &
    
    walls = {(1 |->3), (2 |->1), (2 |->3), (2 |->5), (3 |->3), (4 |->2),
             (4 |->3), (4 |->4), (6 |->1), (6 |->2), (6 |->4), (7 |->4)} &
    
    entry_point = 1 |->1 &
    
    exit_point = 1 |->5

END
