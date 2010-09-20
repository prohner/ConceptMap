    //
//  ConceptObjectTitleViewController.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/19/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObjectTitleViewController.h"
#import "ConceptObject.h"

@implementation ConceptObjectTitleViewController

@synthesize objectTitle, conceptObject;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.contentSizeForViewInPopover = CGSizeMake(195.0, 70.0);

	// No idea why, but wiring from IB wasn't working.  Went old school.
	[objectTitle addTarget:self action:@selector(titleTextHasChanged:) forControlEvents:UIControlEventEditingChanged];	
}

- (void)viewWillAppear:(BOOL)animated { 
	[super viewWillAppear: animated]; // My custom code here 
	objectTitle.text = conceptObject.concept.title;
	[objectTitle becomeFirstResponder];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)titleTextHasChanged:(id)sender {
	conceptObject.concept.title = objectTitle.text;
	[conceptObject.conceptObjectLabel setTitle:conceptObject.concept.title];
	FUNCTION_LOG(@"Title is now (%@)", conceptObject.concept.title);
	[conceptObject.conceptObjectLabel setNeedsDisplay];
}

@end
