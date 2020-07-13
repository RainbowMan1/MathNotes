//
//  NoteCell.h
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedTimeLabel;
@property (strong, nonatomic) Note *note;
@end

NS_ASSUME_NONNULL_END
