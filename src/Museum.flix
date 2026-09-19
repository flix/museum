pub mod Museum {

    use clerk::Clerk
    use entrance::Entrance
    use restaurant::Restaurant
    use giftshop::Giftshop

    pub def visitMuseum(): Unit \ IO = 
        Clerk.welcomeVisitor();
        Entrance.buyTicket();
        Restaurant.buyMeal();
        Giftshop.buyGift()

}
