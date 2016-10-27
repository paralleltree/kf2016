request = window.superagent

CAPACITY = 8

new Vue({
  el: "#wrapper",
  data: {
    max_status_id: 0,
    current_status_index: -1,
    statuses: []
  },
  computed: {
    current_status: ->
      this.statuses[this.current_status_index]
  },
  methods: {
    step: ->
      return unless this.statuses.length > 0
      if this.current_status_index < this.statuses.length - 1
        this.current_status_index += 1
      else
        over = this.statuses.length - CAPACITY
        if over > 0
          this.statuses.splice(0, over)
        this.current_status_index = 0
      return

    fetch: ->
      that = this
      request
        .get("fetch")
      .query(if that.max_status_id == 0 then {} else { max_status_id: that.max_status_id })
      .end((err, res) ->
        if err
          console.log(err)
        else
          switch res.statusCode
            when 200
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
      that.step()
    , 5 * 1000
})
