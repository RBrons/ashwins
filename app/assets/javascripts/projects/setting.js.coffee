$ ->
  $('table#data_table').DataTable
    "bPaginate": false
    "lengthChange": false
    "paginate": false
    "info": false
    "columnDefs": [{
      "targets": 0,
      "orderable": false
    }]

  $(document).find('#data_table_length').hide();
  $('table#data_table2').DataTable
    "paging": false
    "searching": false
    "ordering": false
    "lengthChange": false
    "paginate": false
    "info": false

  $(document).find('#data_table2_info').hide();

