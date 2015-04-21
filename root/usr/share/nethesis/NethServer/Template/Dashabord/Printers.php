<div class="printer-item"><h2>MyPrinter</h2><dl><dt>Status</dt><dd>Idle</dd><dt>Enabled</dt><dd>Yes</dd></dl></div>
<?php

$view->includeCSS("
  div.printer-item {
    margin: 5px;
    padding: 5px;
    border: 1px solid #ccc;
    max-width: 400px;
  }
  .printer-item dt {
    float: left;
    clear: left;
    text-align: right;
    font-weight: bold;
    margin-right: 0.5em;
    padding: 0.1em;
  }
  .printer-item dt:after {
    content: \":\";
  }
  .printer-item dd {
    padding: 0.1em;
  }
  .printer-item h2 {
    font-weight: bold;
    font-size: 120%;
    text-align: center;
    padding: 0.2em;
  }
  .printer-item pre {
      margin-top: 2px;
      padding: 2px;
  }
");

