//
//  ElectricAudioViewController.m
//  ElectricAudio
//
//  Created by Robert McDowell on 07/06/2010.
//  Copyright Electric TopHat Ltd. 2010. All rights reserved.
//

#import "ElectricAudioViewController.h"
#import "UIDevice-Extended.h"
#import "TestUncompressed.h"

@implementation ElectricAudioViewController

#pragma mark ---------------------------------------------------------
#pragma mark === Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

// ------------------------------------------
// Initialization
// ------------------------------------------
- (id) initWithCoder:(NSCoder *)aDecoder
{
	if ( self = [super initWithCoder:aDecoder] )
	{
		tableData = [[NSMutableArray alloc] initWithCapacity:10];
		
		TestUncompressed::AddSection( tableData );
	}
	return self;
}

// ------------------------------------------
// dealloc
// ------------------------------------------
- (void)dealloc 
{
	SAFE_RELEASE( tableView );
	SAFE_RELEASE( tableData );
	
    [super dealloc];
}

#pragma mark ---------------------------------------------------------
#pragma mark === End Constructor / Destructor Functions  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark === UIView Functions  ===
#pragma mark ---------------------------------------------------------

- (void) viewDidLoad
{	
	[tableView reloadData];
}

#pragma mark ---------------------------------------------------------
#pragma mark === End UIView Functions  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark === UITableViewDelegate Functions  ===
#pragma mark ---------------------------------------------------------

// -------------------------------------------------------------------
// did select row at IndexPath
// -------------------------------------------------------------------
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{		
	NSMutableDictionary *	section = [tableData objectAtIndex:indexPath.section];
	NSMutableArray *		data	= [section objectForKey:@"array"];
	NSDictionary *			entry	= [data objectAtIndex:indexPath.row];
	
	NSString * objectNibName = nil;
	if ( [[UIDevice currentDevice] deviceType] == UIDeviceType_iPad )
	{
		objectNibName = [entry objectForKey:@"iPadNib"];
	}
	else 
	{
		objectNibName = [entry objectForKey:@"nib"];
	}

	UIViewController * controller = [[[[entry objectForKey:@"class"] alloc] initWithNibName:objectNibName bundle:nil] autorelease];
	[self.navigationController pushViewController:controller animated:TRUE];
}

#pragma mark ---------------------------------------------------------
#pragma mark === End UITableViewDelegate Functions  ===
#pragma mark ---------------------------------------------------------

#pragma mark ---------------------------------------------------------
#pragma mark === UITableViewDataSource Functions  ===
#pragma mark ---------------------------------------------------------

// -------------------------------------------------------------------
// get the number of sections in the table
// -------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)_tableView 
{
	return [tableData count];
}

// -------------------------------------------------------------------
// get the title for the section
// -------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)_tableView titleForHeaderInSection:(NSInteger)_section
{
	NSMutableDictionary * section = [tableData objectAtIndex:_section];
	return [section objectForKey:@"sectiontitle"];
}

// -------------------------------------------------------------------
// get the bnumber of rows in the table section
// -------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)_section 
{
	NSMutableDictionary *	section = [tableData objectAtIndex:_section];
	NSMutableArray *		data	= [section objectForKey:@"array"];
    return [data count];
}

// -------------------------------------------------------------------
// get the cell for the data
// -------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * cellIdentifier = @"FileListCell";
	UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if ( cell == nil )
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	
	NSMutableDictionary *	section	= [tableData objectAtIndex:indexPath.section];
	NSMutableArray *		data	= [section objectForKey:@"array"];
	NSDictionary *			entry	= [data objectAtIndex:indexPath.row];
	
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	[[cell textLabel] setText:[entry objectForKey:@"name"]];
	
	return cell;
}

#pragma mark ---------------------------------------------------------
#pragma mark === End UITableViewDataSource Functions  ===
#pragma mark ---------------------------------------------------------

@end
