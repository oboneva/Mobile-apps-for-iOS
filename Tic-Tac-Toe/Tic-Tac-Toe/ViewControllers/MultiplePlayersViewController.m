//
//  MultiplePlayersViewController.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 18.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "MultiplePlayersViewController.h"
#import "GameViewController.h"

#import "PlayerModel.h"
#import "HumanModel.h"

#import "GameEngine.h"

#import "Utilities.h"

@interface MultiplePlayersViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstPlayerName;
@property (weak, nonatomic) IBOutlet UITextField *secondPlayerName;
@property (assign) EnumGame gameType;

@end

@implementation MultiplePlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.gameType = EnumGameTicTacToe;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPlayTap:(id)sender {
    GameViewController *gameController = (GameViewController *)[Utilities viewControllerWithClass:GameViewController.class];
    HumanModel *player1 = [[HumanModel alloc] initWithName:self.firstPlayerName.text];
    HumanModel *player2 = [[HumanModel alloc] initWithName:self.secondPlayerName.text];
    
    GameEngine *engine = [Utilities gameEngineFromType:self.gameType];
    engine.player1 = player1;
    engine.player2 = player2;
    [engine setUpPlayers];
    
    [gameController setEngine:engine];
    [self.navigationController pushViewController:gameController animated:YES];
}

- (IBAction)onGameSwitchTap:(id)sender {
    if (self.gameType == EnumGameTicTacToe) {
        self.gameType = EnumGameTunakTunakTun;
    }
    else {
        self.gameType = EnumGameTicTacToe;
    }
}

@end
