pub mod Museum {

    use entrance::Entrance
    use restaurant::Restaurant
    use giftshop::Giftshop

    pub def visitMuseum(): Unit \ IO = 
        Entrance.buyTicket();
        Restaurant.buyMeal();
        Giftshop.buyGift()

}
