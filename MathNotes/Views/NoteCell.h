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
@protocol NoteCellDelegate

- (void) didTapRename:(Note *)note withCompletion: (PFBooleanResultBlock  _Nullable)completion;
- (void) didTapShare:(Note *)note withCompletion: (PFBooleanResultBlock  _Nullable)completion;
- (void) presentSharedUserControllerWithNote:(Note *) note;

@end


@interface NoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *ownerColorView;
@property (weak, nonatomic) IBOutlet UILabel *noteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedTimeLabel;
@property (strong, nonatomic) Note *note;
@property (weak, nonatomic) IBOutlet UIImageView *ownedImage;
@property (weak, nonatomic) IBOutlet UIView *renameNoteView;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (weak, nonatomic) id<NoteCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
