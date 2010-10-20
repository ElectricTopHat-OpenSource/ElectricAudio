//
//  ElectricAudioViewController.h
//  ElectricAudio
//
//  Created by Robert McDowell on 07/06/2010.
//  Copyright Electric TopHat Ltd. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElectricAudioViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
@private
	IBOutlet UITableView *	tableView;
	NSMutableArray *		tableData;
}

@end

