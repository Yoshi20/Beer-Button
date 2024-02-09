import { Controller } from "@hotwired/stimulus"

var i = 0;
var ordersList = [];
var intervalID = 0;

function setOrderTimeAndColor(order) {
  if (order.ctr >= 60) {
    order.td.innerHTML = Math.floor(order.ctr/60)+' min';
    if (order.ctr >= 60*10) {
      order.td.style.color = "red";
    } else if (order.ctr >= 60*5) {
      order.td.style.color = "yellow";
    }
  } else {
    order.td.innerHTML = order.ctr+' s';
  }
}

function startInterval() {
  return setInterval(function() {
    for(var j = 0; j < i; j++) {
      let order = ordersList[j];
      order.ctr++;
      setOrderTimeAndColor(order);
    }
  }, 1000);
}

function addNewOrder(tr) {
  /* Add new order to the orderList */
  ordersList[i] = {
    id: tr.id,
    td: tr.querySelector('td:last-child'),
    ctr: 0
  };
  setOrderTimeAndColor(ordersList[i]);
  i++;
  /* Start timer if required */
  if (intervalID == 0) { // must only be started the very first time
    intervalID = startInterval();
  }
}

export default class extends Controller {
  // static targets = [ "..." ]

  // connect() {
  // }

  newOrderTargetConnected(t) {
    let tr = t;
    /* Show fadeIn */
    tr.classList.add("fadeIn");
    /* Add order to the orderList */
    addNewOrder(tr);
  }

  replacedOrderTargetConnected(t) {
    let tr = t;
    /* Show highlight */
    tr.classList.add("highlight");
    /* Update order in the orderList */
    let found = false;
    for(var j = 0; j < i; j++) {
      let order = ordersList[j];
      if (order.id === tr.id) {
        order.td = tr.querySelector('td:last-child');
        setOrderTimeAndColor(order);
        found = true;
        break;
      }
    }
    /* If not found: Add order to the orderList */
    if (!found) {
      addNewOrder(tr);
    }
  }

  closeOrder(e) {
    /* Show fadeOut before submitting form */
    e.preventDefault();
    let btn = e.target;
    let tr = btn.closest('tr');
    tr.classList.add("fadeOut");
    let form = btn.closest('form');
    setTimeout(function() {
      form.requestSubmit(); // to make use of turbo_stream
    }, 800);
  }

}
