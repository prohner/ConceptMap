//
//  ConceptObjectFontChooserViewController.m
//  ConceptMap
//
//  Created by Preston Rohner on 10/3/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObjectFontChooserViewController.h"
#import "ConceptObject.h"
#import "Utility.h"

@implementation ConceptObjectFontChooserViewController



@synthesize conceptObject, tableHeaderView, fontsArray;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	FUNCTION_LOG();
	self.contentSizeForViewInPopover = CGSizeMake(235.0, 330.0);
	self.title = NSLocalizedString(@"Fonts", @"");
	self.tableView.tableHeaderView = tableHeaderView;

	self.fontsArray = [NSArray arrayWithObjects:
					   [NSArray arrayWithObjects:@"Felt Marker", @"MarkerFelt-Thin", nil],
					   [NSArray arrayWithObjects:@"Times New Roman", @"TimesNewRomanPSMT", nil],
					   [NSArray arrayWithObjects:@"Typewriter", @"AmericanTypewriter", nil],
					   [NSArray arrayWithObjects:@"Verdana", @"Verdana", nil],
					   [NSArray arrayWithObjects:@"Zapfino", @"Zapfino", nil],
					   nil];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [fontsArray count];

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSString *fontName = @"Verdana";
	NSString *fontDesc = @"Verdana";
	if (indexPath.row < [fontsArray count]) {
		fontDesc = [[fontsArray objectAtIndex:indexPath.row] objectAtIndex:0];
		fontName = [[fontsArray objectAtIndex:indexPath.row] objectAtIndex:1];
	}
	FUNCTION_LOG(@"name=%@, desc=%@", fontName, fontDesc);

	cell.textLabel.text = fontDesc;
	cell.textLabel.font = [UIFont fontWithName:fontName size:18.0];
    
	if ([fontName isEqualToString:conceptObject.concept.fontName]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		checkedIndexPath = indexPath;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	NSArray *fonts = fontsArray;
	NSArray *fontInfo = [fonts objectAtIndex:indexPath.row];
	NSString *fontName = [fontInfo objectAtIndex:1];
	conceptObject.concept.fontName = fontName;
	[conceptObject setBodyDisplayStringFont];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	[tableView cellForRowAtIndexPath:checkedIndexPath].accessoryType = UITableViewCellAccessoryNone;
	[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
	checkedIndexPath = indexPath;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
//	self.conceptObject = nil;
	self.fontsArray = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark User Interaction
- (IBAction)makeFontSizeBigger:(id)sender {
	[self stepFontSize: 1];
}

- (IBAction)makeFontSizeSmaller:(id)sender {
	[self stepFontSize:-1];
}
 
- (void)stepFontSize:(int)direction {
	FUNCTION_LOG(@"Step font %i", direction);
	int i = [conceptObject.concept.fontSize intValue];
	i += direction;
	conceptObject.concept.fontSize = [NSNumber numberWithInt:i];
	[conceptObject setBodyDisplayStringFont];
	
}


@end

