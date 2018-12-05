import Koa from 'koa'
import Router from 'koa-router'
import logger from 'koa-logger'
import bodyParser from 'koa-bodyparser'
import cors from '@koa/cors'

import { Voter, accountAddress } from './contract'

var app = new Koa()
var router = new Router()

router
  .post('/redeem', async(ctx, next) => {
    let res

    try {
      let instance = await Voter.deployed()
      res = await instance.redeemToken(ctx.request.body.citizenid_, ctx.request.body.secretKey_ , { from: accountAddress })
    } catch(err) {
      ctx.status = err.status || 500
      ctx.body = err.message
    }
    
    ctx.body = res
  })
  .post('/vote', async(ctx, next) => {
    let res

    try {
      let instance = await Voter.deployed()
      res = await instance.vote(ctx.request.body.citizenid_, ctx.request.body.secretKey_, ctx.request.body.candidate_ , { from: accountAddress })
    } catch(err) {
      ctx.status = err.status || 500
      ctx.body = err.message
    }
      
    ctx.body = res
  })
  .get('/result/:canId', async(ctx, next) => {
    let instance = await Voter.deployed()
    let count = await instance.getCandidateVote(ctx.params.canId)
    count = count.toNumber()

    ctx.body = count
  });

app
  .use(cors())
  .use(logger())
  .use(bodyParser())
  .use(router.routes())
  .use(router.allowedMethods())
  .listen(3000)

console.log('API server listening at port 3000')