/* Robot
 * Author: Lakshan.S w1654456 2016360
 * Creation date: 12/14/19
 */
MACHINE
    Robot

SEES
    Maze
    
SETS
    //Alert Messages after each move
    ALERTS = {Hit_Wall, Out_Of_Boundary, Success, Invalid_First_Move_Teleport};
    
    //Outputs for some operations (isExitFound and isVisitedSquare)
    ANSWERS = {Yes, No}
    
DEFINITIONS
    
    isWall (square) == (square : walls);
    
    isOutOfMaze (square) == (square /: maze);
    
    //Animate the maze and walls
    ANIMATION_FUNCTION_DEFAULT == ({r,c,i| r:1..y_max & c:1..x_max & (IF (isWall(c |-> (succ(y_max)-r)))
                                    THEN i=1 ELSE i=0 END)});
    
    //Animate the position of the Robot
    ANIMATION_FUNCTION == ( {(succ(y_max)-y_position,x_position,2)}  );
    
    ANIMATION_IMG0 == "images/white-square.gif";
    ANIMATION_IMG1 == "images/wall.gif";
    ANIMATION_IMG2 == "images/robot-in-square.gif";
    
    
VARIABLES                           
    x_position, // X Position of the Robot
    y_position, // Y Position of the Robot
    visitedPath // Robot's Visited Path
    
INVARIANT
    x_position: NATURAL1 &
    y_position: NATURAL1 &
    x_position <= x_max & 
    y_position <= y_max &
    visitedPath : seq(maze)
    
INITIALISATION 
    x_position := prj1(1..x_max,1..y_max)(entry_point) ||
    y_position := prj2(1..x_max,1..y_max)(entry_point) ||
    visitedPath:= [entry_point] 
    
OPERATIONS
    // Move the robot to north
    move <-- moveNorth = 
    BEGIN
        IF (isWall (x_position |-> succ(y_position)))
        THEN 
            move := Hit_Wall
        ELSIF (isOutOfMaze (x_position |-> succ(y_position)))
        THEN 
            move := Out_Of_Boundary
        ELSE
            visitedPath := visitedPath <- (x_position |-> succ(y_position)) ||
            y_position, move := succ(y_position), Success
        END
    END;
     
    // Move the robot to south
    move <-- moveSouth = 
    BEGIN
        IF (isWall (x_position |-> pred(y_position)))
        THEN 
            move := Hit_Wall
        ELSIF (isOutOfMaze (x_position |-> pred(y_position)))
        THEN 
            move := Out_Of_Boundary
        ELSE
            visitedPath := visitedPath <- (x_position |-> pred(y_position)) ||
            y_position, move := pred(y_position), Success
        END
    END;
    
    // Move the robot to east
    move <-- moveEast = 
    BEGIN
        IF (isWall (succ(x_position) |-> y_position))
        THEN 
            move := Hit_Wall
        ELSIF (isOutOfMaze (succ(x_position) |-> y_position))
        THEN 
            move := Out_Of_Boundary
        ELSE
            visitedPath := visitedPath <- (succ(x_position) |-> y_position) ||
            x_position, move := succ(x_position), Success
        END
    END;
    
    // Move the robot to west
    move <-- moveWest = 
    BEGIN
        IF (isWall (pred(x_position) |-> y_position))
        THEN 
            move := Hit_Wall
        ELSIF (isOutOfMaze (pred(x_position) |-> y_position))
        THEN 
            move := Out_Of_Boundary
        ELSE
            visitedPath := visitedPath <- (pred(x_position) |-> y_position) ||
            x_position, move := pred(x_position), Success
        END
    END;
    
    //Teleport the robot to a given position
    move <-- teleport (x_target, y_target) =
    PRE x_target : NATURAL1 & y_target : NATURAL1 
    THEN
        IF ( size(visitedPath) = 1 & (x_target |-> y_target) = exit_point)
        THEN
            move := Invalid_First_Move_Teleport
        ELSIF (isWall (x_target |-> y_target))
        THEN
            move := Hit_Wall
        ELSIF (isOutOfMaze (x_target |-> y_target))
        THEN
            move := Out_Of_Boundary
        ELSE
            visitedPath := visitedPath <- (x_target |-> y_target) ||
            x_position, y_position, move := x_target, y_target, Success
        END
    END;
    
    //Check if the robot is in the exitPoint
    isExit <-- isExitFound =
    BEGIN
        IF ((x_position |-> y_position) = exit_point)
        THEN 
            isExit := Yes
        ELSE        
            isExit := No
        END
    END;
    
    //Get the current position of the robot
    position <-- getPosition =
    BEGIN
        position := (x_position |-> y_position)
    END;
    
    //Check if a given location is visited by the robot or not
    isVisited <-- isVisitedSquare(x_point, y_point) =
    PRE x_point : NATURAL1 & y_point : NATURAL1 & (x_point |-> y_point) : maze
    THEN
        IF((x_point |-> y_point) : ran(visitedPath))
        THEN
            isVisited := Yes
          
        ELSE
            isVisited := No
        END
    END;
    
    //Get the visited path of the robot
    path <-- getVisitedPath =
    BEGIN
        path := visitedPath
    END
END
