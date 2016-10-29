request = window.superagent

CAPACITY = 8

new Vue({
  el: "#wrapper",
  data: {
    max_status_id: "",
    current_status_index: -1,
    current_media_index: 0,
    initializing: true,
    failed: false,
    statuses: []
  },
  computed: {
    current_status: ->
      this.statuses[this.current_status_index]
    current_media: ->
      if this.initializing
        { "url": "https://i.ytimg.com/vi/6kR44t-CLvI/maxresdefault.jpg" }
      else
        this.current_status["media"][this.current_media_index]
  },
  methods: {
    step: ->
      return unless this.statuses.length > 0

      # increment media index
      if this.current_status_index != -1 && this.current_media_index < this.current_status["media"].length - 1
          this.current_media_index += 1
          return

      # increment status index
      this.current_media_index = 0
      if this.current_status_index < this.statuses.length - 1
        this.current_status_index += 1
      else
        over = this.statuses.length - CAPACITY
        if over > 0
          this.statuses.splice(0, over)
        this.current_status_index = 0
      this.initializing = false
      return

    fetch: ->
      that = this
      request
        .get("fetch")
      .query({ limit: CAPACITY, max_status_id: that.max_status_id })
      .end((err, res) ->
        if err
          console.log(err)
          that.failed = true
        else
          switch res.statusCode
            when 200
              that.failed = false
              sts = res.body
              # push statuses
              for element in sts
                that.statuses.push(element)
              # update the last status id
              if sts.length > 0
                that.max_status_id = sts[sts.length - 1]["id"]
              return
      )
      return
  },
  created: ->
    that = this
    this.fetch()
    setInterval ->
      that.fetch()
    , 10 * 1000
    setInterval ->
      that.step()
    , 5 * 1000
})
