@AbapCatalog.sqlViewName: 'ZVI_BOOKING'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking View'
@Metadata.ignorePropagatedAnnotations: true
@ClientHandling: {
    type: #INHERITED,
    algorithm: #SESSION_VARIABLE
}
define view YE_BOOKING
  as select from /dmo/booking
{
  //key client        as Mandt,
  key travel_id     as TravelId,
  key booking_id    as BookingId,
      booking_date  as BookingDate,
      customer_id   as CustomerId,
      carrier_id    as CarrierId,
      connection_id as ConnectionId,
      flight_date   as FlightDate,
      flight_price  as FlightPrice,
      currency_code as CurrencyCode
}
