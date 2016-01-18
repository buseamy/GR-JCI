  <!-- Include the page header.php file -->
  <?php include('header.php'); ?>
  <body>
    <article>
      <!--Page Heading-->
      <h1>We&rsquo;ll be available soon!</h1>
      <div>
        <!--Main paragraph-->
        <p>
          Sorry for the inconvenience but the JCI is under construction by the Grand Rapids Ferris ISYS 489 class at the moment.
        </p>
        <p>
          If you would like you can sign-up below to be notified once the site goes live!
        </p>
        <!--Embeded Map-->
        <iframe class="map" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2919.5921167615943!2d-85.66679238486361!3d42.96579920462515!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x88184dddec4bfcef%3A0x99d94ffe6ec0120b!2sFerris+State+University+-+Grand+Rapids!5e0!3m2!1sen!2sus!4v1453083076540" width="400" height="325" frameborder="0" style="border:0;" allowfullscreen></iframe>
        <!--Sign-up form-->
        <form class="email-notification">
          <div class="row">
            <label for="name">Name:</label><br />
            <input id="name" class="input" name="name" type="text" value="" size="30" /><br />
          </div>
          <div class="row">
            <label for="email">Email:</label><br />
            <input id="email" class="input" name="email" type="text" value="" size="30" /><br />
          </div>
          <input id="submit_button" type="submit" value="Sign-up" />
        </form>
        <!--Signature-->
        <p>&mdash; ISYS 489</p>
      </div>
    </article>
  </body>
  <!-- Include the page footer.php file -->
  <?php include('footer.php'); ?>
