class ReservationsDatasource {
  Future<Map<String, dynamic>> getReservationsSummary() async {
    return {
      'checkInsPending': 5,
      'checkOutsPending': 3,
      'paymentsPending': 2,
    };
  }
}
