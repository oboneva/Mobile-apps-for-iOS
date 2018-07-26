//
//  GameViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "GameEngine.h"

#import "GameViewController.h"
#import "MatrixCollectionViewController.h"

#import "PlayerModel.h"

#import "Utilities.h"
#import "Protocols.h"

@interface GameViewController () <NotifyPlayerToPlayDelegate, EndGameDelegate>

@property (weak, nonatomic) IBOutlet UIView *matrixView;
@property (strong, nonatomic) MatrixCollectionViewController *matrixViewController;

@property (weak, nonatomic) IBOutlet UILabel *player1InfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *player2InfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *endOfGameLabel;
@property (strong, nonatomic) UIColor *labelsColour;
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.player1InfoLabel.text = self.engine.player1.name;
    [self.player1InfoLabel sizeToFit];
    self.player2InfoLabel.text = self.engine.player2.name;
    [self.player2InfoLabel sizeToFit];
    self.endOfGameLabel.text = @"";
    
    self.labelsColour = [[UIColor alloc] initWithRed:255/255 green:102/255 blue:102/255 alpha:1.0];
    [self.startNewGameButton setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.matrixViewController = (MatrixCollectionViewController *)[Utilities viewControllerWithClass:MatrixCollectionViewController.class];
    self.matrixViewController = segue.destinationViewController;
    self.matrixViewController.engine = self.engine;
    self.matrixViewController.notifyPlayerToPlayDelegate = self;
    self.matrixViewController.endGameDelegate = self;
}

-(void)didChangePlayerToPlayWithName:(NSString *)playerName {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([playerName isEqualToString:self.engine.player1.name]) {
            self.player1InfoLabel.textColor = self.labelsColour;
            self.player2InfoLabel.textColor = [UIColor grayColor];
        }
        else {
            self.player1InfoLabel.textColor = [UIColor grayColor];
            self.player2InfoLabel.textColor = self.labelsColour;
        }
    });
}

- (void)didEndGameWithNoWinner {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.endOfGameLabel.text = @"No winner";
        self.endOfGameLabel.textColor = self.labelsColour;
        self.matrixView.userInteractionEnabled = NO;
        [self.startNewGameButton setHidden:NO];
    });
}

- (void)didEndGameWithWinner:(PlayerModel *)winner {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.endOfGameLabel.text = [[NSString alloc] initWithFormat:@"%@ won", winner.name];
        self.endOfGameLabel.textColor = self.labelsColour;
        [self.endOfGameLabel sizeToFit];
        self.matrixView.userInteractionEnabled = NO;
        [self.startNewGameButton setHidden:NO];
    });
}

-(void)forceRefresh {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.matrixViewController.collectionView reloadData];
    });
}

- (IBAction)onNewGameTap:(id)sender {
    [self.startNewGameButton setHidden:YES];
    self.endOfGameLabel.text = @"";
    [self.engine newGame];
    self.matrixView.userInteractionEnabled = YES;
}

@end
