//
//  ConceptMapAppDelegate.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright Cool Tool Apps 2010. All rights reserved.
//

#import "ConceptMapAppDelegate.h"
#import "ConceptMapViewController.h"

@implementation ConceptMapAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch. 
	if ([[DATABASE documents] count] <= 0) {
		Document *doc;
		Concept *concept;
		UIImage *image;
		
		doc = [DATABASE newDocumentTitled:@"doc 2"];
		image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image2" ofType:@"jpeg"]];
		doc.image = UIImageJPEGRepresentation(image, 1.0);

		concept = [DATABASE newConceptTitled:@"concept 3" toDocument:doc];
		concept.originX = [NSNumber numberWithInt: 300];
		concept.originY = [NSNumber numberWithInt: 300];
		concept.height = [NSNumber numberWithInt: 200];
		concept.width = [NSNumber numberWithInt: 200];
		concept.bodyDisplayString = @"body string";
		[DATABASE saveManagedObjectContext];
		
		doc = [DATABASE newDocumentTitled:@"doc 1"];
		image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image1" ofType:@"jpeg"]];
		doc.image = UIImageJPEGRepresentation(image, 1.0);

		concept = [DATABASE newConceptTitled:@"concept 1" toDocument:doc];
		concept.originX = [NSNumber numberWithInt: 100];
		concept.originY = [NSNumber numberWithInt: 100];
		concept.height = [NSNumber numberWithInt: 200];
		concept.width = [NSNumber numberWithInt: 200];
		concept.bodyDisplayString = @"body string";
		
		concept = [DATABASE newConceptTitled:@"concept 2" toDocument:doc];
		concept.originX = [NSNumber numberWithInt: 400];
		concept.originY = [NSNumber numberWithInt: 400];
		concept.height = [NSNumber numberWithInt: 200];
		concept.width = [NSNumber numberWithInt: 200];
		concept.bodyDisplayString = @"body string";
		[DATABASE saveManagedObjectContext];

	}
	
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	FUNCTION_LOG(@"Saving object context");
	[DATABASE saveManagedObjectContext];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
