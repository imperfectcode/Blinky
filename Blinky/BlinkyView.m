//
//  BlinkyView.m
//  Blinky
//
//  Created by David Robinson on 08-FEB-02018.
//  Edited  by David Robinson on 20-FEB-02018.
//  Copyright © 2018 Imperfect Code. All rights reserved.
//
//  Originally based on the tutorial "Write a Screen Saver: Part I" by Brian Christensen
//  http://cocoadevcentral.com/articles/000088.php
//
//  Heavily modified by David Robinson
//

#import "BlinkyView.h"

@implementation BlinkyView

static NSString * const MyModuleName = @"online.imperfectcode.Blinky";

bool DEBUG_SET = FALSE;
bool DEBUG_ONCE = FALSE;

bool CLEAR_RESET = TRUE;
unsigned int CLEAR_CYCLE=0;
bool CLEAR_FULL = FALSE;
unsigned int CLEAR_FULL_CYCLE=0;
unsigned int CLEAR_FULL_CYCLE_SET=0;

float WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_SHORT, WINDOW_LONG, WINDOW_WIDTH_OLD;
unsigned int WINDOW_TALL=0;

unsigned int COUNT_SHORT, COUNT_LONG;
float ORIGIN_SHORT, ORIGIN_LONG;
float BOX_SIZE;
float BOX_GUTTER;
unsigned int BOX_NUMBER;
float OFFSET_SHORT, OFFSET_LONG;
float BUFFER_SHORT, BUFFER_LONG;

unsigned int SHAPE_TYPE;

unsigned int COLOUR_RANDOM;
unsigned int COLOUR_CYCLE;
unsigned int COLOUR_CYCLE_RESET;

float COLOUR_H, COLOUR_S, COLOUR_B, COLOUR_A;

unsigned int CLEAR_COUNT;
unsigned int LOOP_COUNT=5;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self)
    {
        ScreenSaverDefaults *defaults;
        defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
        
        // Register our default values
        [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                    @"NO", @"DrawFilledShapes",
                                    @"NO", @"DrawOutlinedShapes",
                                    @"YES", @"DrawBoth",
                                    @"NO", @"DebugMode",
                                    nil]];
        
        [self setAnimationTimeInterval:1/30.0];
        if (isPreview) {
            //COUNT_SHORT = SSRandomIntBetween(3,13);
            //BOX_GUTTER = SSRandomIntBetween(5,15);
        }
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    NSBezierPath *path;
    //NSRect rect;
    
    NSRect RECT_WINDOW;
    NSRect RECT_LIGHT;
    NSRect RECT_CLEAR;
    
    NSSize WINDOW_SIZE;
    NSColor *color;
    ScreenSaverDefaults *defaults;
    
    WINDOW_SIZE = self.bounds.size;
    
    WINDOW_WIDTH = WINDOW_SIZE.width;
    WINDOW_HEIGHT = WINDOW_SIZE.height;
    
    //if ( WINDOW_WIDTH_OLD == !WINDOW_WIDTH )
    //{
    //    CLEAR_RESET = TRUE;
    //}
    
    WINDOW_WIDTH_OLD = WINDOW_WIDTH;
    
    if ( WINDOW_WIDTH < WINDOW_HEIGHT )
    {
        WINDOW_LONG = WINDOW_HEIGHT;
        WINDOW_SHORT = WINDOW_WIDTH;
        WINDOW_TALL = 1;
    }
    else
    {
        WINDOW_LONG = WINDOW_WIDTH;
        WINDOW_SHORT = WINDOW_HEIGHT;
        WINDOW_TALL = 0;
    }
    
    CLEAR_FULL_CYCLE_SET++;
    if (CLEAR_FULL_CYCLE_SET > 10000)
    {
        CLEAR_RESET=TRUE;
        CLEAR_FULL_CYCLE_SET=0;
    }
    
    // Set initial conditions
    if ( CLEAR_RESET )
    {
        COLOUR_CYCLE_RESET =SSRandomIntBetween( 101, 997);
        COLOUR_CYCLE = COLOUR_CYCLE_RESET + 1;
        
        COUNT_SHORT = SSRandomIntBetween( 5, 47);
        
        //CLEAR_COUNT = pow(COUNT_SHORT,0.5);
        
        // Calculate box size
        BOX_SIZE = WINDOW_SHORT / COUNT_SHORT;
        
        BOX_GUTTER = SSRandomFloatBetween( 5, ( floor(  BOX_SIZE - 1 ) ) );
        COUNT_LONG = floor( WINDOW_LONG / BOX_SIZE );
        
        BOX_NUMBER = COUNT_SHORT * COUNT_LONG;
        
        if ( [defaults boolForKey:@"DebugMode"] || DEBUG_SET )
        {
            NSLog(@"blinkytest - BOX_SIZE %f",BOX_SIZE);
            NSLog(@"blinkytest - WINDOW_SHORT %f",WINDOW_SHORT);
            NSLog(@"blinkytest - WINDOW_LONG %f",WINDOW_LONG);
            NSLog(@"blinkytest - COUNT_SHORT %d",COUNT_SHORT);
            NSLog(@"blinkytest - COUNT_LONG %d",COUNT_LONG);
            NSLog(@"blinkytest - BOX_GUTTER %f",BOX_GUTTER);
        }
        
        BUFFER_SHORT = ( WINDOW_SHORT - ( BOX_SIZE * COUNT_SHORT) ) / (COUNT_SHORT-1);
        BUFFER_LONG = ( WINDOW_LONG - ( BOX_SIZE * COUNT_LONG) ) / (COUNT_LONG-1);
        
        RECT_WINDOW.size = NSMakeSize( WINDOW_WIDTH, WINDOW_HEIGHT );
        RECT_WINDOW.origin = NSMakePoint( 0 , 0 ) ;
        path = [NSBezierPath bezierPathWithRect:RECT_WINDOW];
        color = [NSColor blackColor];
        [color set];
        [path fill];
        
        CLEAR_RESET = FALSE;
    }
    
    // Change colours
    COLOUR_CYCLE++;
    if ( COLOUR_CYCLE > COLOUR_CYCLE_RESET ) {
        COLOUR_CYCLE = 0;
        CLEAR_COUNT = pow( COUNT_SHORT, 0.2 ) * SSRandomIntBetween( 1, 9 );
        COLOUR_S = 1.0;
        COLOUR_B = 1.0;
        COLOUR_A = 1.0;
        COLOUR_RANDOM = SSRandomIntBetween( 0, 3 );
        switch ( COLOUR_RANDOM )
        {
            case 0:
                COLOUR_RANDOM = SSRandomIntBetween( 0, 12 );
                switch (COLOUR_RANDOM)
            {
                case 0: // white
                default:
                    COLOUR_H = (CGFloat)0/360;
                    COLOUR_S = 0.0;
                    break;
                case 1: // red
                    COLOUR_H = (CGFloat)0/360;
                    break;
                case 2: // orange
                    COLOUR_H = (CGFloat)30/360;
                    break;
                case 3: // yellow
                    COLOUR_H = (CGFloat)60/360;
                    break;
                case 4: // chartreuse green
                    COLOUR_H = (CGFloat)90/360;
                    break;
                case 5: // green
                    COLOUR_H = (CGFloat)120/360;
                    break;
                case 6: // spring green
                    COLOUR_H = (CGFloat)150/360;
                    break;
                case 7: // cyan
                    COLOUR_H = (CGFloat)180/360;
                    break;
                case 8: // azure
                    COLOUR_H = (CGFloat)210/360;
                    break;
                case 9: // blue
                    COLOUR_H = (CGFloat)240/360;
                    break;
                case 10: // violet
                    COLOUR_H = (CGFloat)270/360;
                    break;
                case 11: // magenta
                    COLOUR_H = (CGFloat)300/360;
                    break;
                case 12: // rose
                    COLOUR_H = (CGFloat)330/360;
                    break;
            }
            case 1:
            case 2:
            case 3:
            default:
                COLOUR_RANDOM = SSRandomIntBetween( 0, 5 );
                switch (COLOUR_RANDOM)
            {
                case 0: // white
                default:
                    COLOUR_H = (CGFloat)0/360;
                    COLOUR_S = 0.0;
                    break;
                case 1: // red
                    COLOUR_H = (CGFloat)0/360;
                    break;
                case 2: // orange
                    COLOUR_H = (CGFloat)30/360;
                    break;
                case 3: // yellow
                    COLOUR_H = (CGFloat)60/360;
                    break;
                case 4: // green
                    COLOUR_H = (CGFloat)120/360;
                    break;
                case 5: // blue
                    COLOUR_H = (CGFloat)240/360;
                    break;
            }
        }
    }
    
    
    if ( [defaults boolForKey:@"DebugMode"] || DEBUG_SET )
    {
        if ( !DEBUG_ONCE )
        {
            // when debugging, clear the whole window with white
            DEBUG_ONCE =TRUE;
            RECT_WINDOW.size = NSMakeSize( WINDOW_WIDTH, WINDOW_HEIGHT );
            RECT_WINDOW.origin = NSMakePoint( 0 , 0 ) ;
            path = [NSBezierPath bezierPathWithRect:RECT_WINDOW];
            color = [NSColor whiteColor];
            [color set];
            [path fill];
        }
    }
    
    if ([defaults boolForKey:@"DebugMode"] || DEBUG_SET )
    {
        // when debugging, run many more loops of the drawing cycles
        LOOP_COUNT = pow( COUNT_SHORT, 0.5) * 100;
    }
    else
    {
        LOOP_COUNT = pow( COUNT_SHORT, 0.5) ;
    }
    
    RECT_CLEAR.size = NSMakeSize( BOX_SIZE , BOX_SIZE );
    RECT_LIGHT.size = NSMakeSize( BOX_SIZE - (BOX_GUTTER/2) , BOX_SIZE - (BOX_GUTTER/2) );
    
    if ( CLEAR_FULL )
    {
        CLEAR_FULL_CYCLE++;
        if (CLEAR_FULL_CYCLE > BOX_NUMBER * 5)
        {
            CLEAR_FULL = FALSE;
            CLEAR_RESET = TRUE;
            CLEAR_FULL_CYCLE = 0;
        }
    }
    else
    {
        // loop to draw lights on the screen
        for (int i=0; i<LOOP_COUNT; i++)
        {
            OFFSET_LONG = SSRandomIntBetween( 0, COUNT_LONG-1);
            OFFSET_SHORT = SSRandomIntBetween( 0, COUNT_SHORT-1);
            
            //NSLog(@"OFFSET_LONG %d",OFFSET_LONG);
            //NSLog(@"OFFSET_SHORT %d",OFFSET_SHORT);
            
            ORIGIN_LONG = ( OFFSET_LONG*BOX_SIZE ) + OFFSET_LONG*BUFFER_LONG ;
            ORIGIN_SHORT = ( OFFSET_SHORT*BOX_SIZE ) + OFFSET_SHORT*BUFFER_SHORT ;
            
            //NSLog(@"ORIGIN_LONG %d",ORIGIN_LONG);
            //NSLog(@"ORIGIN_SHORT %d",ORIGIN_SHORT);
            //NSLog(@"WINDOW_LONG %d",WINDOW_LONG);
            //NSLog(@"WINDOW_SHORT %d",WINDOW_SHORT);
            
            if ( WINDOW_TALL == 0 ) {
                RECT_CLEAR.origin = NSMakePoint( ORIGIN_LONG , ORIGIN_SHORT ) ;
                RECT_LIGHT.origin = NSMakePoint( ORIGIN_LONG + (BOX_GUTTER/4) , ORIGIN_SHORT + (BOX_GUTTER/4) ) ;
            }
            else
            {
                RECT_CLEAR.origin = NSMakePoint( ORIGIN_SHORT , ORIGIN_LONG ) ;
                RECT_LIGHT.origin = NSMakePoint( ORIGIN_SHORT + (BOX_GUTTER/4) , ORIGIN_LONG + (BOX_GUTTER/4) ) ;
            }
            
            path = [NSBezierPath bezierPathWithRect:RECT_CLEAR];
            
            // before drawing a shape, clear the space with black
            
            color = [NSColor blackColor];
            [color set];
            // And finally draw it
            [path fill];
            
            // Decide what kind of shape to draw
            // old code that changed the shape draw... could be useful for debugging
            //SHAPE_TYPE = SSRandomIntBetween( 0, 1 );
            
            SHAPE_TYPE = 1;
            
            if ([defaults boolForKey:@"DebugMode"] || DEBUG_SET )
            {
                SHAPE_TYPE = 1;
            }
            
            switch (SHAPE_TYPE)
            {
                case 0: // rect
                    path = [NSBezierPath bezierPathWithRect:RECT_LIGHT];
                    break;
                    
                case 1: // circle
                default:
                    path = [NSBezierPath bezierPathWithOvalInRect:RECT_LIGHT];
                    break;
            }
            
            
            
            // Calculate a random color
            COLOUR_B = SSRandomFloatBetween( 0.0, 1.0 );
            //NSLog(@"blinkytest - COLOUR_B1 %f",COLOUR_B);
            COLOUR_B = pow( COLOUR_B, 2 );
            // make brighter lights less common
            //NSLog(@"blinkytest - COLOUR_B2 %f",COLOUR_B);
            
            if ( [defaults boolForKey:@"DebugMode"] || DEBUG_SET )
            {
                color = [NSColor colorWithCalibratedHue:COLOUR_H
                                             saturation:COLOUR_S
                                             brightness:1.0
                                                  alpha:COLOUR_A];
            }
            else
            {
                color = [NSColor colorWithCalibratedHue:COLOUR_H
                                             saturation:COLOUR_S
                                             brightness:COLOUR_B
                                                  alpha:COLOUR_A];
            }
            
            [color set];
            
            // And finally draw it
            defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
            
            //if ([defaults boolForKey:@"DrawBoth"])
            //{
            //    if (SSRandomIntBetween( 0, 1 ) == 0)
            [path fill];
            //    else
            //        [path stroke];
            //}
            //else if ([defaults boolForKey:@"DrawFilledShapes"])
            //    [path fill];
            //else
            //    [path stroke];
            
        }
        
    }
    
    // and clear some boxes
    
    CLEAR_COUNT = pow( BOX_NUMBER, 0.5);
    
    for (int i=0; i<(CLEAR_COUNT); i++)
    {
        
        RECT_CLEAR.size = NSMakeSize( BOX_SIZE , BOX_SIZE );
        
        // Calculate random origin point
        
        OFFSET_LONG = SSRandomIntBetween( 0, COUNT_LONG-1);
        OFFSET_SHORT = SSRandomIntBetween( 0, COUNT_SHORT-1);
        
        ORIGIN_LONG = ( OFFSET_LONG*BOX_SIZE ) + OFFSET_LONG*BUFFER_LONG;
        ORIGIN_SHORT = ( OFFSET_SHORT*BOX_SIZE ) + OFFSET_SHORT*BUFFER_SHORT;
        
        if ( WINDOW_TALL == 0 ) {
            RECT_CLEAR.origin = NSMakePoint( ORIGIN_LONG , ORIGIN_SHORT ) ;
        }
        else
        {
            RECT_CLEAR.origin = NSMakePoint( ORIGIN_SHORT , ORIGIN_LONG ) ;
        }
        
        // Make a rectangle
        path = [NSBezierPath bezierPathWithRect:RECT_CLEAR];
        
        if ( ![defaults boolForKey:@"DebugMode"] && !DEBUG_SET )
        {
            color = [NSColor blackColor];
            [color set];
            // And finally draw it
            [path fill];
        }
        else
        {
            color = [NSColor whiteColor];
            [color set];
            // And finally draw it
            [path stroke];
        }
    }
    
    return;
    
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
    ScreenSaverDefaults *defaults;
    
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    
    if (!configSheet)
    {
        if (![NSBundle loadNibNamed:@"ConfigureSheet" owner:self])
        {
            NSLog( @"Failed to load configure sheet." );
            NSBeep();
        }
    }
    
    [drawFilledShapesOption setState:[defaults boolForKey:@"DrawFilledShapes"]];
    [drawOutlinedShapesOption setState:[defaults boolForKey:@"DrawOutlinedShapes"]];
    [drawBothOption setState:[defaults boolForKey:@"DrawBoth"]];
    [debugModeOption setState:[defaults boolForKey:@"DebugMode"]];
    
    return configSheet;
}

- (IBAction)cancelClick:(id)sender
{
    [[NSApplication sharedApplication] endSheet:configSheet];
}

- (IBAction)okClick:(id)sender
{
    ScreenSaverDefaults *defaults;
    
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    
    // Update our defaults
    [defaults setBool:[drawFilledShapesOption state] forKey:@"DrawFilledShapes"];
    [defaults setBool:[drawOutlinedShapesOption state] forKey:@"DrawOutlinedShapes"];
    [defaults setBool:[drawBothOption state] forKey:@"DrawBoth"];
    [defaults setBool:[debugModeOption state] forKey:@"DebugMode"];
    
    // Save the settings to disk
    [defaults synchronize];
    
    // Close the sheet
    [[NSApplication sharedApplication] endSheet:configSheet];
}

@end
