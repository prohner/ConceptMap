//
//  ConceptMapViewController.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright Cool Tool Apps 2010. All rights reserved.
//

#import "ConceptMapViewController.h"

@implementation ConceptMapViewController

@synthesize toolbar, documentsButton, documentTitle, documentTitleHolder;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	CGRect frame = CGRectMake(0, 0, 200, 30);
	self.documentTitle = [[UITextField alloc] initWithFrame:frame];
	documentTitle.borderStyle = UITextBorderStyleRoundedRect;
	documentTitle.textColor = [UIColor blackColor];
	documentTitle.font = [UIFont systemFontOfSize:17.0];
	documentTitle.placeholder = @"<Enter Document Title>";
	documentTitle.backgroundColor = [UIColor blackColor];
	//documentTitle.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	documentTitle.autocapitalizationType = UITextAutocapitalizationTypeWords;
	documentTitle.keyboardType = UIKeyboardTypeDefault;
	documentTitle.returnKeyType = UIReturnKeyDone;
	documentTitle.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
//	documentTitleHolder.customView = documentTitle;
	[documentTitle addTarget:self action:@selector(documentTitleChanged:) forControlEvents:UIControlEventEditingChanged];

	NSMutableArray *items = [toolbar.items mutableCopy];
	int titleIndex = [items indexOfObject:documentTitleHolder];

	documentTitleHolder = [[UIBarButtonItem alloc] initWithCustomView:documentTitle];
	//[items addObject:documentTitleHolder];
	[items replaceObjectAtIndex:titleIndex withObject:documentTitleHolder];
	toolbar.items = items;
	//[documentTitleHolder release];
	
	[self setConceptMapView];
}

- (void)setConceptMapView {
	if (conceptMapView) {
		[conceptMapView removeFromSuperview];
		[conceptMapView release];
		conceptMapView = nil;
	}
	
	documentTitle.text = [DATABASE currentDocument].title;
    CGRect viewFrame = self.view.frame;
    viewFrame.origin = CGPointMake(0, toolbar.bounds.size.height);
    conceptMapView = [[ConceptMapView alloc] initWithFrame:viewFrame];
    conceptMapView.contentSize = [conceptMapView idealContentSize];
	conceptMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
    [self.view addSubview:conceptMapView];
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	FUNCTION_LOG();
    return YES;
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//	FUNCTION_LOG();
//	//	if (popoverController) {
//	//		CGPoint point = [mapView convertCoordinate:[selectedAnnotation coordinate] toPointToView:mapView];
//	//		[popoverController presentPopoverFromRect:CGRectMake(point.x - 30, point.y - 34, 60, 40) inView:mapView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//	//	}
//}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.documentTitle = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)documentButtonTapped:(id)sender {
	FUNCTION_LOG();
	
	UIGraphicsBeginImageContext(self.view.bounds.size);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	conceptMapView.currentDocument.image = UIImageJPEGRepresentation(viewImage, 1.0);
	UIGraphicsEndImageContext();
	
	documentsViewController = [[[DocumentsViewController alloc] initWithNibName:@"DocumentsViewController" bundle:nil] retain];
	documentsViewController.conceptMapViewController = self;
	
	UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:documentsViewController];
	
	UIPopoverController *popover = [[[UIPopoverController alloc] 
									 initWithContentViewController:navCtrl] retain];
	[popover presentPopoverFromBarButtonItem:documentsButton 
					permittedArrowDirections:UIPopoverArrowDirectionAny 
									animated:YES];
	[navCtrl release];
}

- (IBAction)addConcept:(id)sender {
	FUNCTION_LOG(@"View=(%i), Doc=(%i)", conceptMapView, conceptMapView.currentDocument);

	CGRect r = CGRectMake(40, 40, 200, 200);
	Concept *concept = [DATABASE newConceptTitled:@"New Item" 
									   toDocument:conceptMapView.currentDocument];
	[concept setRect:r];
	ConceptObject *co = [ConceptObject conceptObjectWithConcept:concept];
	[co setFrame:r];
	co.backgroundColor = [UIColor darkGrayColor];
	
	
	CABasicAnimation *theAnimation;	
	theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
	theAnimation.duration=0.15;
	theAnimation.repeatCount=2;
	theAnimation.autoreverses=YES;
	theAnimation.fromValue=[NSNumber numberWithFloat:20];
	theAnimation.toValue=[NSNumber numberWithFloat:45];
	[co.layer addAnimation:theAnimation forKey:@"animateLayer"];	
	[conceptMapView addConceptObject:co toView:conceptMapView];
}

- (IBAction)documentTitleChanged:(id)sender {
	[DATABASE currentDocument].title = documentTitle.text;
}

@end
